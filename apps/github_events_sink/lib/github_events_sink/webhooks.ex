defmodule GithubEventsSink.Webhooks do
  @moduledoc """
  The Webhooks context.
  """
  require Logger

  @doc """
  POST to the webhook

  ## Examples
      iex> post_webhook(%{field: bad_value}, [])
      {:error, %{}}

  """
  @spec post_webhook(payload :: map(), headers :: list(Headers.kv_tuple())) ::
          {:ok, map()} | {:error, term()}
  def post_webhook(payload, headers) do
    dispatch(payload, Headers.to_map(headers))
  end

  @spec dispatch(payload :: map(), headers :: %{String.t() => [String.t()]}) ::
          {:ok, map()} | {:error, term()}
  # Unrecognised webhook
  def dispatch(payload, headers) do
    Enum.each(headers, fn {key, value} ->
      Logger.debug("#{key}: #{value}")
    end)

    case payload do
      %{} ->
        pretty_log_payload(payload)
        {:ok, {}}

      _ ->
        Logger.debug("payload: #{inspect(payload)}")
        {:error, :unrecognized}
    end
  end

  defp pretty_log_payload(payload) do
    case Jason.encode(payload, pretty: true) do
      {:ok, s} ->
        Logger.debug("payload:\n#{s}")

      _ ->
        Logger.debug("payload: #{inspect(payload)}")
    end
  end
end
