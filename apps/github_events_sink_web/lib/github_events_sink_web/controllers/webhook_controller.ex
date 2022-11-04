defmodule GithubEventsSinkWeb.WebhookController do
  use GithubEventsSinkWeb, :controller

  alias GithubEventsSink.Webhooks

  require Logger

  action_fallback(GithubEventsSinkApi.FallbackController)

  @spec hook(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def hook(conn, %{"path" => _path} = _params) do
    payload = conn.body_params

    case Webhooks.post_webhook(payload, conn.req_headers) do
      {:ok, _result} ->
        send_resp(conn, :no_content, "")

      {:error, :unrecognized} ->
        Logger.debug(conn.body_params)
        send_resp(conn, :no_content, "")

      _ ->
        send_resp(conn, :internal_server_error, "")
    end
  rescue
    e ->
      Logger.error(Exception.format(:error, e, __STACKTRACE__))
      send_resp(conn, :internal_server_error, "")
  end

  def hook(conn, _) do
    send_resp(conn, :bad_request, "")
  end
end
