defmodule NanoWallet.Wallet.Transfer do
  use NanoWallet.Wallet.Model
  alias NanoWallet.Wallet.Transfer

  embedded_schema do
    field(:amount_string, :string)
    field(:amount, Money.Ecto)
    field(:destination_username, :string)
    field(:description, :string)

    embeds_one(:source_customer, User)
    embeds_one(:destination_customer, User)
  end

  def changeset(user, struct, params \\ Map.new()) do
    struct
    |> cast(params, [:amount_string, :destination_username, :description])
    |> validate_required([:amount_string, :destination_username, :description])
    |> validate_format(:amount_string, ~r/\A\d+\.\d{2}\Z/, message: "is invalid")
    |> put_embed(:source_customer, user)
    |> put_destination_customer(user)
  end

  defp put_destination_customer(%{valid?: false} = changeset, _), do: changeset

  defp put_destination_customer(changeset, source_customer) do
    username = get_change(changeset, :destination_username)

    if username == source_customer.username do
      add_error(changeset, :destination_username, "cannot transfer to the same account")
    else
      case Repo.one(from(c in User, where: c.username == ^username, preload: :wallet)) do
        %User{} = customer ->
          put_embed(changeset, :destination_customer, customer)

        nil ->
          add_error(changeset, :destination_username, "is invalid")
      end
    end
  end

  def create(customer, params) do
    changeset = changeset(customer, %Transfer{}, params)

    if changeset.valid? do
      transfer = apply_changes(changeset)
      source_account = customer.wallet
      destination_account = transfer.destination_customer.wallet

      amount = Money.new(transfer.amount_string <> " " <> destination_account.currency)
      transfer = %{transfer | amount: amount}

      transactions =
        build_transactions(source_account, destination_account, transfer.description, amount)

      case Ledger.write(transactions) do
        {:ok, _} ->
          :ok = send_message(transfer)
          {:ok, transfer}

        {:error, :insufficient_funds} ->
          changeset = add_error(changeset, :amount_string, "insufficient funds")
          {:error, changeset}
      end
    else
      {:error, changeset}
    end
  end

  defp build_transactions(source, destination, description, amount) do
    [
      {:debit, source, description, amount},
      {:credit, destination, description, amount}
    ]
  end

  defp send_message(transfer) do
    subject = "You've received #{transfer.amount} from #{transfer.source_customer.username}"
    # :ok = Messenger.deliver_email(transfer.destination_username, subject, subject)
    :ok
  end
end
