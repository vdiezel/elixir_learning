defmodule Calc do

  # order matters for pattern matching!
  def divide(_a, 0) do
    {:error, :zero_division}
  end

  def divide(a, b) do
    a / b
  end

  def add(a) do
    add a, 0
  end

  def add(a, b) do
    a + b
  end

  #def add(a, b, \\ 0) do
  #  a + b
  #end

  def fac(0), do 1

  def fac(a) when is_integer(a) and a > 0 do
    a * fac(a - 1)
  end

  def fac(_) do
    { :error, :invalid_argument } #fallback clause
  end
end
