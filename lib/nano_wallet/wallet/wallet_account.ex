defmodule NanoWallet.Wallet.WalletAccount do
  use Ecto.Schema
  import Ecto.Changeset
  alias NanoWallet.Accounts.User

  schema "wallet_accounts" do
    field(:currency, :string)
    field(:name, :string)
    field(:type, :string)

    field(:user_id, :id)

    # belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(wallet_account, attrs) do
    wallet_account
    |> cast(attrs, [:type, :name, :currency])
    |> validate_required([:type, :name, :currency])
  end
end
