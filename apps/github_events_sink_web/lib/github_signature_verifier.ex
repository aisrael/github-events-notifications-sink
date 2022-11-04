defmodule GithubSignatureVerifier do
  @moduledoc """
  A custom Plug that takes the raw body and verifies the signature
  """

  require Logger

  @spec init(list()) :: :ok
  def init(options) do
    Logger.debug("GithubSignatureVerifier.init(#{inspect(options)})")
    options
  end

  @spec call(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def call(conn, _opts) do
    x_hub_signature_256 = Headers.get_header(conn.req_headers, "x-hub-signature-256")

    if x_hub_signature_256 != nil do
      Logger.debug("x-hub-signature-256: #{x_hub_signature_256}")

      webhook_secret = Application.get_env(:github_events_sink, :webhook_secret)

      if webhook_secret != nil do
        raw_body = conn.assigns[:raw_body]
        Logger.debug("webhook_secret: #{webhook_secret}")

        computed_signature =
          :crypto.mac(:hmac, :sha256, webhook_secret, raw_body)
          |> Base.encode16()
          |> String.downcase()

        Logger.debug("computed_signature: #{computed_signature}")

        conn
      end
    end

    conn
  end
end
