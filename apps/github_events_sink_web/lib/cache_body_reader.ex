defmodule CacheBodyReader do
  @moduledoc """
  A Plug custom body reader to cache the raw request body for later verification.

  See https://hexdocs.pm/plug/Plug.Parsers.html#module-custom-body-reader
  """

  @spec read_body(Plug.Conn.t(), keyword) :: {:ok, binary, map}
  def read_body(conn, opts) do
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)
    conn = update_in(conn.assigns[:raw_body], &[body | &1 || []])
    {:ok, body, conn}
  end
end
