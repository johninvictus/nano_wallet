defmodule NanoWalletWeb.Router do
  use NanoWalletWeb, :router

  pipeline :api_auth do
    plug(NanoWallet.Guardian.AuthPipeline)
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", NanoWalletWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api", NanoWalletWeb do
    pipe_through(:api)

    post("/sessions/register", UserController, :create)
    post("/sessions/login", SessionController, :create)
  end

  scope "/api", NanoWalletWeb do
    pipe_through([:api, :api_auth])

    resources("/users", UserController, except: [:new, :edit])
  end

  # Other scopes may use custom stacks.
  # scope "/api", NanoWalletWeb do
  #   pipe_through :api
  # end
end
