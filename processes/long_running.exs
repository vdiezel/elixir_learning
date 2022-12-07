# "server" processes

defmodule GameClient do
  def play(initial_stones \\ 30) do
    GameServer.start(initial_stones)
    start_game!()
  end

  defp start_game! do
    send :game_server, { :info, self() }
    receive do
      { player, current_stones } ->
          IO.puts "Starting the game! It's player #{player} turn There are #{current_stones} in the pile"
    end

    take()
  end

  defp stones_to_take({ count, _}), do: count
  defp stones_to_take(:error), do: nil

  defp ask_stones do
    IO.gets("\nPlease take from 1 to 3 stones:\n")
    |> String.trim
    |> Integer.parse
    |> stones_to_take
  end

  defp take do
    send :game_server, {:take, self(), ask_stones()}
    receive do
      { :next_turn, next_player, stones } ->
        IO.puts "\n Player #{next_player} turn. Stones: #{stones}"
        take()
      { :winner, winner} ->
        IO.puts "\n Player #{winner} wins"
      { :error, reason } ->
        IO.puts "\n Error: #{reason}"
        take()
      after 5000 -> IO.puts "Server Timeout"
    end
  end
end

defmodule GameServer do
  def start(initial_stones) do
    spawn(fn -> listen({ 1, initial_stones }) end)
    |> Process.register(:game_server)
  end

  defp listen({ nil, 0 }), do: listen({1, 30}) #restart game

  defp listen({ player, current_stones } = current_state) do
    new_state = receive do
      { :info, sender } ->
        do_info sender, current_state
      { :take, sender, num_stones } ->
        do_take({ sender, player, num_stones, current_stones })
      _ -> current_state
    end

    listen(new_state)
  end

  defp do_info(sender, current_state) do
    send sender, current_state
    current_state
  end

  defp do_take({ sender, player, num_stones_take, current_stones }) when
  not is_integer(num_stones_take) or
      num_stones_take < 1 or
      num_stones_take > 3 or
      num_stones_take > current_stones do
        send sender, { :error, "You can take from 1 to 3 stones, and maximum #{current_stones}" }

      { player, current_stones }
  end

  defp do_take({ sender, player, num_stones_take, current_stones }) when
  num_stones_take === current_stones do
    send sender, { :winner, next_player(player) }

    {nil, 0}
  end

  defp do_take({ sender, player, num_stones_take, current_stones }) do
    next = next_player(player)
    new_stones_count = current_stones - num_stones_take
    send sender, { :next_turn, next, new_stones_count }
    { next, new_stones_count }
  end

  defp next_player(1), do: 2
  defp next_player(2), do: 1
end

GameClient.play(10)
