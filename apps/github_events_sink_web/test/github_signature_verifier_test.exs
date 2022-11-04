defmodule MyPlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts GithubSignatureVerifier.init([])

  test "returns hello world" do
    body = Jason.encode!(%{foo: "bar"})

    # Create a test connection
    conn = conn(:post, "/hello", body)

    # Invoke the plug
    conn = GithubSignatureVerifier.call(conn, @opts)
  end
end
