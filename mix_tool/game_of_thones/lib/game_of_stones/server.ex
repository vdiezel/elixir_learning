defmodule GameOfStones.Server do
  use GenServer, restart: :transient
  @server_name __MODULE__

  def start_link(_) do
    # :started
    # :game_in_progress
    # :game_ended
    GenServer.start_link(@server_name, :started, name: @server_name)
  end

  def set_stones(stones) do
    GenServer.call(@server_name, { :set_stones, stones })
  end

  def take(stones) do
    GenServer.call(@server_name, { :take, stones })
  end

  # Call backs
  def init(:started) do
    {:ok, { 1, 0, :started }}
  end

  def handle_call({ :set_stones, initial }, _, { player, _, :started }) do
    new_state = { player, initial, :game_in_progress }
    new_state |> GameOfStones.Storage.store
    { :reply, new_state, new_state }
  end

  def handle_call({ :take, stones }, _, { player, current_stones, :game_in_progress }) do
    reply = do_take { player, stones, current_stones }
    elem(reply, 2) |> GameOfStones.Storage.store
    reply
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
        { player, current_stones, :game_in_progress }
      }
  end

  def do_take({ player, num_stones_take, current_stones }) when
    num_stones_take === current_stones do
    GameOfStones.Storage.fetch_all |> IO.inspect
      { :stop, :normal, {:winner, next_player(player)}, {nil, 0, :game_ended }}
  end

  def do_take({ player, num_stones_take, current_stones }) do
    next = next_player(player)
    new_stones = current_stones - num_stones_take
    { :reply, { :next_turn, next, new_stones }, { next, new_stones, :game_in_progress }}
  end

  defp next_player(1), do: 2
  defp next_player(2), do: 1
end

GameOfStones.GameClient.play()
