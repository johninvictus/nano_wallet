defmodule NanoWallet.Wallet.WalletEntry do
  use NanoWallet.Wallet.Model

  @entry_types [:credit, :debit]

  schema "wallet_entries" do
    field :amount, Money.Ecto
    field :description, :string
    field :type, :string

    belongs_to(:account, WalletAccount)

    timestamps()
  end

  @doc false
  def changeset(wallet_entry, attrs) do
    wallet_entry
    |> cast(attrs, [:type, :description, :amount])
    |> validate_required([:type, :description, :amount])
  end

  def from_tuple({type, %WalletAccount{} = account, description, %Money{} = amount})
  when type in @entry_types and is_binary(description) do
    %WalletEntry{
      type: Atom.to_string(type),
      account: account,
      description: description,
      amount: amount
    }
  end
end
