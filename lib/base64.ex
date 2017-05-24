defmodule Base64 do
  @moduledoc """
  Implement Base64 Encoding according to RFC 4648.
  """

  import Bitwise

  alphabet = Enum.with_index('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/')

  for {encoding, index} <- alphabet do
    defp enc(unquote(index)), do: unquote(encoding)
    defp dec(unquote(encoding)), do: unquote(index)
  end

  @doc """
  Encode arbitrary string.

  Example:

      iex> Base64.encode("a")
      "YQ=="
      iex> Base64.encode("abc")
      "YWJj"
  """
  @spec encode(String.t) :: String.t
  def encode(str) do
    do_encode(str)
  end

  @doc """
  Decode base64 encoded string.

  Example:

      iex> Base64.decode("YQ==")
      {:ok, "a"}
      iex> Base64.decode("YWJj")
      {:ok, "abc"}
      iex> Base64.decode("error")
      :error
  """
  @spec decode(String.t) :: {:ok, String.t} | :error
  def decode(str) do
    {:ok, decode!(str)}
  rescue
    _ -> :error
  end

  @doc """
  Decode base64 encoded string. May raise error.

  Example:

      iex> Base64.decode!("YQ==")
      "a"
      iex> Base64.decode!("YWJj")
      "abc"
  """
  @spec encode(String.t) :: String.t
  def decode!(str) do
    do_decode(str)
  end

  defp do_encode(""), do: ""
  defp do_encode(<<a::6, t::2>>) do
    <<enc(a)::8, enc(bsl(t, 4))::8, ?=, ?=>>
  end
  defp do_encode(<<a::6, b::6, t::4>>) do
    <<enc(a)::8, enc(b)::8, enc(bsl(t, 2))::8, ?=>>
  end
  defp do_encode(<<a::6, b::6, c::6, d::6, t::binary>>) do
    <<enc(a)::8, enc(b)::8, enc(c)::8, enc(d)::8, do_encode(t)::binary>>
  end

  defp do_decode(""), do: ""
  defp do_decode(<<a::8, b::8, ?=, ?=>>) do
    <<dec(a)::6, bsr(dec(b), 4)::2>>
  end
  defp do_decode(<<a::8, b::8, c::8, ?=>>) do
    <<dec(a)::6, dec(b)::6, bsr(dec(c), 2)::4>>
  end
  defp do_decode(<<a::8, b::8, c::8, d::8, t::binary>>) do
    <<dec(a)::6, dec(b)::6, dec(c)::6, dec(d)::6, do_decode(t)::binary>>
  end
  defp do_decode(_), do: raise ArgumentError, "incorrect padding"
end
