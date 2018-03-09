defmodule NanoWallet.Wallet do
  @moduledoc """
  The Wallet context.
  """

  import Ecto.Query, warn: false
  alias NanoWallet.Repo

  alias NanoWallet.Wallet.WalletAccount

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
end
