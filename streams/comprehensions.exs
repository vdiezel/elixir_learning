defmodule Comp do
  def demo(list) do
    for el <- list, do: el * 2
  end

end

Comp.demo([1, 2, 3]) |> IO.inspect
