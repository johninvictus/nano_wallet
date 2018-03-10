defmodule NanoWallet.Wallet.WalletEntry do
  use Ecto.Schema
  import Ecto.Changeset


  schema "wallet_entries" do
    field :amount, :string
    field :description, :string
    field :type, :string
    field :account_id, :id

    timestamps()
  end

  @doc false
  def changeset(wallet_entry, attrs) do
    wallet_entry
    |> cast(attrs, [:type, :description, :amount])
    |> validate_required([:type, :description, :amount])
  end
end
