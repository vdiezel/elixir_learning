# sometimes dots are used to indicate hierarchy, but
# for Elixir, there is no notion of hierarchy

# all module names are atoms!
defmodule Calc do
  #import IO
  alias IO, as: DemoIO

  def plus(a, b) do
    do_some_priv_stuff()
    a + b
  end

  # def plus(a, b), do: a + b

  def mult(a,b), do: a * b

  #private functions
  defp do_some_priv_stuff(), do: "private stuff" |> DemoIO.puts
end

# piping (backed by currying)
IO.puts Calc.plus(1, 2) |> Calc.mult(3)

# non-prefixed functions are coming from the Kernel module, like length
