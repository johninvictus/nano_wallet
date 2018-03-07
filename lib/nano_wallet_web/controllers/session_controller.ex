defmodule NanoWalletWeb.SessionController do
  use NanoWalletWeb, :controller
  alias NanoWallet.Accounts

  action_fallback(NanoWalletWeb.FallbackController)

  def create(conn, params) do
    with {:ok, accounts} <- Accounts.authenticate_user(params) do
      conn
      |> put_status(:ok)
      |> render("show.json", accounts)
    end
  end
end
