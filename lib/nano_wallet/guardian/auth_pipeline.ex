defmodule NanoWallet.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :nano_wallet,
    module: NanoWallet.Guardian,
    error_handler: NanoWallet.Guardian.AuthErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, allow_blank: true)
end
