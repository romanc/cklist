defmodule CklistWeb.Cldr do
  @moduledoc """
    Define a backend module that will host our
    Cldr configuration and public API.

    Most function calls in Cldr will be calls
    to functions on this module.
  """

  use Cldr,
    otp_app: :cklist

  @doc "Returns the currently set locale for a connection"
  @spec locale(Plug.Conn.t()) :: String.t()
  def locale(conn) do
    Cldr.Plug.AcceptLanguage.get_cldr_locale(conn)
  end

  @doc "Returns a number as an ordinal string"
  @spec to_ordinal(number) :: String.t()
  def to_ordinal(number) do
    __MODULE__.Number.to_string!(number, format: :ordinal)
  end

  @doc "Returns a number as an ordinal string using the set locale"
  @spec to_ordinal(number, Plug.Conn.t()) :: String.t()
  def to_ordinal(number, conn) do
    __MODULE__.Number.to_string!(number, format: :ordinal, locale: locale(conn))
  end

  @doc "Returns a number as a string with no decimals"
  @spec to_int_string(number) :: String.t()
  def to_int_string(number) do
    __MODULE__.Number.to_string!(number, precision: 0)
  end

  @doc "Returns a number as a string with no decimals using the set locale"
  @spec to_int_string(number, Plug.Conn.t()) :: String.t()
  def to_int_string(number, conn) do
    __MODULE__.Number.to_string!(number, precision: 0, locale: locale(conn))
  end

  @doc "Returns a number of bytes as a string"
  @spec to_mb_string(number_of_bytes :: number, precision :: non_neg_integer) :: String.t()
  def to_mb_string(number_of_bytes, precision \\ 2) do
    Cldr.Unit.new!(:byte, number_of_bytes)
    |> Cldr.Unit.convert!(:megabyte)
    |> Cldr.Unit.round(precision)
    |> Cldr.Unit.to_string!(unit: :megabyte, style: :narrow)
  end
end
