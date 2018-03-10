defmodule NanoWallet.Repo.Migrations.CreateWalletEntries do
  use Ecto.Migration

  def change do
    # create type
    execute("""
    CREATE TYPE moneyz AS (
      cents integer,
      currency varchar
    );
    """)

    create table(:wallet_entries) do
      add(:type, :string)
      add(:description, :string)
      add(:amount, :moneyz)
      add(:account_id, references(:wallet_accounts, on_delete: :nothing))

      timestamps()
    end

    create(index(:wallet_entries, [:account_id]))
  end
end
