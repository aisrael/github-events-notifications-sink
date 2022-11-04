defmodule Headers do
  @moduledoc """
  Utility functions for dealing with Plug request headers.
  """

  @type kv_tuple :: {String.t(), String.t()}

  @doc """
  Returns true if the given header key is present in the headers list.
  """
  @spec has_header(list(kv_tuple), String.t()) :: boolean
  def has_header(headers, key), do: Enum.any?(headers, fn {k, _} -> k == key end)

  @spec get_header(list(kv_tuple), String.t()) :: String.t()
  def get_header(headers, key) do
    case Enum.find(headers, fn {k, _} -> k == key end) do
      {_k, v} -> v
      _ -> nil
    end
  end

  @doc """
  Converts a headers list (`[{key, val1}, ...]`) into a Map of `%{key => [val1, ...], ...}`
  """
  @spec to_map(list(kv_tuple)) :: %{String.t() => [String.t()]}
  def to_map(headers) do
    Enum.reduce(headers, %{}, fn {key, value}, map ->
      Map.update(map, key, [value], &(&1 ++ [value]))
    end)
  end
end
