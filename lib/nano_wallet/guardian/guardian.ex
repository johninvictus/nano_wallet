defmodule NanoWallet.Guardian do
  use Guardian, otp_app: :nano_wallet

  alias NanoWallet.Accounts

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  def resource_from_claims(claims) do
    user = Accounts.get_user!(claims["sub"])
    {:ok, user}
  end
end
