defmodule NanoWallet.Wallet.Ledger do
  use NanoWallet.Wallet.Model
  alias NanoWallet.Repo
  alias NanoWallet.Wallet.WalletEntry

  def deposits_account do
    Repo.get_by(WalletAccount, name: "Deposits") ||
      Repo.insert!(WalletAccount.build_asset("Deposits"))
  end

  def balance(%WalletAccount{id: id, type: type, currency: currency}) do
    q =
      from(
        t in WalletEntry,
        select:
          fragment(
            "SUM(CASE WHEN b0.type = 'credit' THEN (b0.amount).cents ELSE -(b0.amount).cents END)"
          ),
        where: t.account_id == ^id
      )

    balance = Repo.one(q) || 0
    balance = do_balance(balance, type)

    %Money{cents: balance, currency: currency}
  end

  defp do_balance(balance, "liability"), do: +balance
  defp do_balance(balance, "asset"), do: -balance

  def write(entries) do
    Repo.transaction_with_isolation(
      fn ->
        with :ok <- same_currencies(entries),
             {:ok, persisted_entries} <- insert(entries),
             :ok <- credits_equal_debits(),
             :ok <- sufficient_funds(persisted_entries) do
          persisted_entries
        else
          {:error, reason} ->
            Repo.rollback(reason)
        end
      end,
      level: :serializable
    )
  end

  def same_currencies(entries) do
    {_, _, _, %Money{currency: currency}} = hd(entries)

    currencies =
      Enum.flat_map(entries, fn {_, %WalletAccount{currency: a}, _, %Money{currency: b}} ->
        [a, b]
      end)

    if Enum.uniq(currencies) == [currency] do
      :ok
    else
      {:error, :different_currencies}
    end
  end

  def entries(%WalletAccount{id: id}) do
    Repo.all(from(t in WalletEntry, where: t.account_id == ^id))
  end

  defp insert(entries) do
    entries =
      Enum.map(entries, fn tuple ->
        WalletEntry.from_tuple(tuple)
        |> Repo.insert!()
      end)

    {:ok, entries}
  end

  defp credits_equal_debits do
    q = from(e in WalletEntry, select: fragment("SUM((b0.amount).cents)"))
    credits = Repo.one!(from(e in q, where: e.type == "credit"))
    debits = Repo.one!(from(e in q, where: e.type == "debit"))

    if credits == debits do
      :ok
    else
      {:error, :credits_not_equal_debits}
    end
  end

  defp sufficient_funds(entries) do
    accounts = Enum.map(entries, & &1.account)

    if Enum.all?(accounts, fn account -> balance(account).cents >= 0 end) do
      :ok
    else
      {:error, :insufficient_funds}
    end
  end
end
