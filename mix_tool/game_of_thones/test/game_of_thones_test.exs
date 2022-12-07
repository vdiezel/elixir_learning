defmodule GameOfThonesTest do
  use ExUnit.Case
  doctest GameOfThones

  test "greets the world" do
    assert GameOfThones.hello() == :world
  end
end
