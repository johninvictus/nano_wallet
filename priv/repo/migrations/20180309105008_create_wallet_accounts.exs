defmodule NanoWallet.Repo.Migrations.CreateWalletAccounts do
  use Ecto.Migration

  def change do
    create table(:wallet_accounts) do
      add(:type, :string)
      add(:name, :string)
      add(:currency, :string)

      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create(index(:wallet_accounts, [:user_id]))
    create(index(:wallet_accounts, [:name], unique: true))
  end
end
