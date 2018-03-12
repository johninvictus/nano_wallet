defmodule NanoWallet.Wallet do
  @moduledoc """
  The Wallet context.
  """

  import Ecto.Query, warn: false
  alias NanoWallet.Repo

  alias NanoWallet.Wallet.WalletAccount
  alias NanoWallet.Wallet.Deposit
  alias NanoWallet.Wallet.Ledger

  @doc """
  Returns the list of wallet_accounts.

  ## Examples

      iex> list_wallet_accounts()
      [%WalletAccount{}, ...]

  """
  def list_wallet_accounts do
    Repo.all(WalletAccount)
  end

  @doc """
  Gets a single wallet_account.

  Raises `Ecto.NoResultsError` if the Wallet account does not exist.

  ## Examples

      iex> get_wallet_account!(123)
      %WalletAccount{}

      iex> get_wallet_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet_account!(id), do: Repo.get!(WalletAccount, id)

  @doc """
  Creates a wallet_account.

  ## Examples

      iex> create_wallet_account(%{field: value})
      {:ok, %WalletAccount{}}

      iex> create_wallet_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet_account(attrs \\ %{}) do
    %WalletAccount{}
    |> WalletAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet_account.

  ## Examples

      iex> update_wallet_account(wallet_account, %{field: new_value})
      {:ok, %WalletAccount{}}

      iex> update_wallet_account(wallet_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet_account(%WalletAccount{} = wallet_account, attrs) do
    wallet_account
    |> WalletAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WalletAccount.

  ## Examples

      iex> delete_wallet_account(wallet_account)
      {:ok, %WalletAccount{}}

      iex> delete_wallet_account(wallet_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet_account(%WalletAccount{} = wallet_account) do
    Repo.delete(wallet_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet_account changes.

  ## Examples

      iex> change_wallet_account(wallet_account)
      %Ecto.Changeset{source: %WalletAccount{}}

  """
  def change_wallet_account(%WalletAccount{} = wallet_account) do
    WalletAccount.changeset(wallet_account, %{})
  end

  alias NanoWallet.Wallet.WalletEntry

  @doc """
  Returns the list of wallet_entries.

  ## Examples

      iex> list_wallet_entries()
      [%WalletEntry{}, ...]

  """
  def list_wallet_entries do
    Repo.all(WalletEntry)
  end

  @doc """
  Gets a single wallet_entry.

  Raises `Ecto.NoResultsError` if the Wallet entry does not exist.

  ## Examples

      iex> get_wallet_entry!(123)
      %WalletEntry{}

      iex> get_wallet_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_wallet_entry!(id), do: Repo.get!(WalletEntry, id)

  @doc """
  Creates a wallet_entry.

  ## Examples

      iex> create_wallet_entry(%{field: value})
      {:ok, %WalletEntry{}}

      iex> create_wallet_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_wallet_entry(attrs \\ %{}) do
    %WalletEntry{}
    |> WalletEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a wallet_entry.

  ## Examples

      iex> update_wallet_entry(wallet_entry, %{field: new_value})
      {:ok, %WalletEntry{}}

      iex> update_wallet_entry(wallet_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_wallet_entry(%WalletEntry{} = wallet_entry, attrs) do
    wallet_entry
    |> WalletEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WalletEntry.

  ## Examples

      iex> delete_wallet_entry(wallet_entry)
      {:ok, %WalletEntry{}}

      iex> delete_wallet_entry(wallet_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_wallet_entry(%WalletEntry{} = wallet_entry) do
    Repo.delete(wallet_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking wallet_entry changes.

  ## Examples

      iex> change_wallet_entry(wallet_entry)
      %Ecto.Changeset{source: %WalletEntry{}}

  """
  def change_wallet_entry(%WalletEntry{} = wallet_entry) do
    WalletEntry.changeset(wallet_entry, %{})
  end

  def create_deposit!(account, amount) do
    {:ok, result} =
      Deposit.build(account, amount)
      |> Ledger.write()

    result
  end
end
