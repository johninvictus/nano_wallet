defmodule NanoWallet.Wallet.Deposit do
  use NanoWallet.Wallet.Model

  def build(%User{wallets: wallet}, %Money{} = amount) do
    build(wallet, amount)
  end

  def build(%WalletAccount{} = wallet, %Money{} = amount) do
    descriprion = "Deposit"

    [
      {:debit, Ledger.deposits_account(), descriprion, amount},
      {:credit, wallet, descriprion, amount}
    ]
  end
end
