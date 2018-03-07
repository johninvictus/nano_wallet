defmodule NanoWalletWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use NanoWalletWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(NanoWalletWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(NanoWalletWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(NanoWalletWeb.ErrorView, "error.json", message: "Wrong password!")
  end

  def call(conn, {:error, :user_not_found}) do
    conn
    |> put_status(:unauthorized)
    |> render(NanoWalletWeb.ErrorView, "error.json", message: "No user with the specified email!")
  end
end
