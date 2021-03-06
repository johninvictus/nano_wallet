defmodule NanoWallet.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias NanoWallet.Accounts.User
  alias NanoWallet.Wallet.WalletAccount

  schema "users" do
    field(:email, :string)
    field(:username, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    has_many(:wallets, WalletAccount)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attr) do
    user
    |> changeset(attr)
    |> cast(attr, [:password])
    |> validate_required([:password])
    |> put_hash()
  end

  def put_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(password))

      _ ->
        changeset
    end
  end

  def build(%{"username" => username} = params) do
    registration_changeset(%User{}, params)
    |> put_assoc(:wallets, [WalletAccount.build_wallet("Wallet: #{username}")])
  end
end
