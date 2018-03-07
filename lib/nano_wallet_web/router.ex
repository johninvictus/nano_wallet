defmodule NanoWalletWeb.Router do
  use NanoWalletWeb, :router

  pipeline :api_auth do
    plug(NanoWallet.Guardian.AuthPipeline)
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NanoWalletWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", NanoWalletWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", NanoWalletWeb do
  #   pipe_through :api
  # end
end
