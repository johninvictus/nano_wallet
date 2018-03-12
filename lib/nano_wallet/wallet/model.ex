defmodule NanoWallet.Wallet.Model do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      alias NanoWallet.{
        Wallet.Deposit,
        Accounts.User,
        Money,
        Wallet.Ledger,
        Wallet.WalletAccount,
        Wallet.WalletEntry,
        Repo
      }
    end
  end
end
