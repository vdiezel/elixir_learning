defmodule ListUtils do
  def alt_mult(list), do: alt_mult([ 1 | list])

  def mult(list), do: do_mult(1, list)

  defp do_mult(current_val, []), do: current_val
  defp do_mult(current_val, [head | tail ]) do
    current_val * head |>
    do_mult(tal)
  end

  # exercise: tail-call optimized factorial
  def fac(n), do: do_fac(1, a)

  defp do_fac(result, 0), do: result
  defp do_fac(a, n) do
    a * n |>
    do_fac(n - 1)
  end
end
