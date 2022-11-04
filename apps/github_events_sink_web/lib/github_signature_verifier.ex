defmodule GithubSignatureVerifier do
  @moduledoc """
  A custom Plug that takes the raw body and verifies the signature
  """

  alias Plug.Conn

  require Logger

  @spec init(list()) :: :ok
  def init(options) do
    Logger.debug("GithubSignatureVerifier.init(#{inspect(options)})")
    options
  end

  @spec call(Plug.Conn.t(), list()) :: Plug.Conn.t()
  def call(conn, _opts) do
    case get_header(conn.req_headers, "x-hub-signature-256") do
      "sha256=" <> signature = x_hub_signature_256 ->
        Logger.debug("x-hub-signature-256: #{x_hub_signature_256}")
        webhook_secret = Application.get_env(:github_events_sink, :webhook_secret)
        validate_signature(conn, webhook_secret, signature)

      _ ->
        conn |> Conn.put_status(:unauthorized) |> Conn.halt()
    end
  end

  defp validate_signature(conn, webhook_secret, signature)
       when is_binary(webhook_secret) and is_binary(signature) do
    raw_body = conn.assigns[:raw_body]
    Logger.debug("webhook_secret: #{webhook_secret}")

    computed_signature =
      :crypto.mac(:hmac, :sha256, webhook_secret, raw_body)
      |> Base.encode16()
      |> String.downcase()

    Logger.debug("computed_signature: #{computed_signature}")

    if signature == computed_signature do
      conn
    end
  end

  defp validate_signature(conn, _, _),
    do: conn |> Conn.put_status(:unauthorized) |> Conn.halt()

  defp get_header(headers, key) do
    case Enum.find(headers, fn {k, _} -> k == key end) do
      {_k, v} -> v
      _ -> nil
    end
  end
end
