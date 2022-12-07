defmodule GameOfStones.GameClient do
  def play(stones \\ 30) do
    GameOfStones.GameServer.start(stones)
    start_game!()
  end

  defp start_game! do
    case GameOfStones.GameServer.stats do
      {player, current_stones} ->
        IO.puts "Welcome! It's player #{player} turn. #{current_stones} stones in the pile"
    end

    take()
  end

  defp take() do
    case GameOfStones.GameServer.take( ask_stones() ) do
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

defmodule GameOfStones.GameServer do
  use GenServer
  @server_name __MODULE__

  def start(stones \\ 30) do
    GenServer.start(@server_name, stones, name: @server_name)
    {:ok, { 1, stones }}
  end

  def stats do
    GenServer.call(@server_name, :stats)
  end

  def take(stones) do
    GenServer.call(@server_name, { :take, stones })
  end

  # Call backs
  def init(stones) do
    {:ok, { 1, stones }}
  end

  def handle_call(:stats, _, current_state) do
    {:reply, current_state, current_state }
  end

  def handle_call({ :take, stones }, _, { player, current_stones }) do
    do_take { player, stones, current_stones }
  end

  def terminate(_, _) do
    "See you soon" |> IO.puts
  end

  ### handlers

  def do_take({ player, num_stones_take, current_stones }) when
    not is_integer(num_stones_take) or
      num_stones_take < 1 or
      num_stones_take > 3 or
      num_stones_take > current_stones do
      {
        :reply,
        { :error, "Invalid amount of stones" },
        { player, current_stones }
      }
  end

  def do_take({ player, num_stones_take, current_stones }) when
    num_stones_take === current_stones do
      { :stop, :normal, {:winner, next_player(player)}, {nil, 0}}
  end

  def do_take({ player, num_stones_take, current_stones }) do
    next = next_player(player)
    new_stones = current_stones - num_stones_take
    { :reply, { :next_turn, next, new_stones }, { next, new_stones }}
  end

  defp next_player(1), do: 2
  defp next_player(2), do: 1
end

GameOfStones.GameClient.play()
