defmodule NanoWalletWeb.SessionView do
  use NanoWalletWeb, :view

  alias NanoWalletWeb.UserView
  alias NanoWallet.Accounts

  def render("show.json", accounts) do
    %{
      meta: %{
        token: accounts.token,
        duration: "30 days"
      },
      user: render_one(accounts.user, UserView, "user.json")
    }
  end
end
