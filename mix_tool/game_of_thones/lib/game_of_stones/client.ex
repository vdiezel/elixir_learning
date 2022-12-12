defmodule GameOfStones.GameClient do

  def main(argv) do
    parse(argv) |> play
  end

  def parse(argv) do
    {opts, _, _ } = OptionParser.parse(argv, switches: [stones: :integer])
    opts |> Keyword.get(:stones, 30)
  end

  def play(stones \\ 30) do
    case GameOfStones.Server.set_stones(stones) do
      { player, current_stones, :game_in_progress } ->
        IO.puts "Welcome! It's player #{player} turn. #{current_stones} stones in the pile"
    end

    take()
  end

  defp take() do
    case GameOfStones.Server.take( ask_stones() ) do
      {:next_turn, next, stones } ->
        IO.puts("\nPlayer #{next} turns next. Stones: #{stones}")
        take()
      {:winner, winner } ->
        IO.puts("\nPlayer #{winner} wins!")
      {:error, reason } ->
        IO.puts("\nThere was an error #{reason}")
        take()
    end
  end

  defp ask_stones() do
    IO.gets("\nTake from 1 to 3 stones\n")
    |> String.trim
    |> Integer.parse
    |> stones_to_take()
  end

  defp stones_to_take({ count, _}), do: count
  defp stones_to_take(:error), do: 0
end

