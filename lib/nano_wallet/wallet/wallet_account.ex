defmodule NanoWallet.Wallet.WalletAccount do
  use Ecto.Schema
  import Ecto.Changeset

  alias NanoWallet.Wallet.WalletAccount
  alias NanoWallet.Accounts.User

  @account_types ~w(asset liability)

  schema "wallet_accounts" do
    field(:currency, :string)
    field(:name, :string)
    field(:type, :string)

    belongs_to(:user, User)

    timestamps()
  end

  def build_asset(name) do
    changeset(%WalletAccount{}, Map.put(%{type: "asset", currency: "KSH"}, :name, name))
  end

  def build_wallet(name) do
    changeset(%WalletAccount{}, Map.put(%{type: "liability", currency: "KSH"}, :name, name))
  end

  @doc """
  Builds a changeset based on the `struct` and `params`
  """
  def changeset(wallet_account, attrs) do
    wallet_account
    |> cast(attrs, [:type, :name, :currency])
    |> validate_required([:type, :name, :currency])
    |> unique_constraint(:name)
    |> validate_inclusion(:type, @account_types)
  end
end
