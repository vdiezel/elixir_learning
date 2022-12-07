defmodule GameOfStones.Server do
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
