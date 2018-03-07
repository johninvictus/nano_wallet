defmodule NanoWallet.Accounts do
  @moduledoc """
  The Accounts context.
  """
  defstruct user: nil, token: nil

  import Ecto.Query, warn: false
  import Comeonin.Argon2, only: [checkpw: 2, dummy_checkpw: 0]
  alias NanoWallet.Repo
  alias NanoWallet.Guardian

  alias NanoWallet.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Will register a user after a user is provided

  iex> register_user(%{correct values}) # when attrs are Map.new
  {:ok, account}

  iex> register_user(%{bad values})

  {:error, changeset}
  """
  def register_user(attrs) do
    case create_user(attrs) do
      {:ok, user} ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: :access)

        {:ok, %__MODULE__{user: user, token: token}}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def authenticate_user(%{"email" => mail, "password" => password}) do
    user = get_user_by_email(mail)

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, token_type: :access)

        {:ok, %__MODULE__{user: user, token: token}}

      user ->
        {:error, :unauthorized}

      true ->
        dummy_checkpw()
        {:error, :user_not_found}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def changeset_register(%User{} = user) do
    User.registration_changeset(user, Map.new())
  end
end
