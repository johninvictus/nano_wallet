defmodule NanoWallet.Repo.Migrations.CreateWalletAccounts do
  use Ecto.Migration

  def change do
    create table(:wallet_accounts) do
      add(:type, :string, null: false)
      add(:name, :string, null: false)
      add(:currency, :string, null: false)

      add(:user_id, references(:users, on_delete: :delete_all))

      timestamps()
    end

    create(index(:wallet_accounts, [:user_id]))
    create(index(:wallet_accounts, [:name], unique: true))
  end
end
