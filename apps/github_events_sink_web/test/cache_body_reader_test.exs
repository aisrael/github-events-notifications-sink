defmodule CacheBodyReaderTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "captures the :raw_body" do
    # Create a test connection
    conn = conn(:post, "/hello", Jason.encode!(%{foo: "bar"}))

    # Invoke the plug
    {:ok, _body, conn} = CacheBodyReader.read_body(conn, [])

    # Assert the response and status
    assert conn.assigns[:raw_body] == [~s({"foo":"bar"})]
  end
end
