defmodule NanoWallet.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do

    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :auth_account_id])
    |> validate_required([:username, :email, :auth_account_id])
  end
end
