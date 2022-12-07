defmodule Demo do
  use GenServer

  def start(init_state  \\ 0) do
    GenServer.start(Demo, init_state, name: __MODULE__)
  end

  def sqrt() do
    GenServer.cast(__MODULE__, :sqrt)
  end

  def add(number) do
    GenServer.cast(__MODULE__, { :add, number })
  end

  def result() do
    # default timeout is 5000 ms
    GenServer.call(__MODULE__, :result)
  end

  # Asynchronous request
  def handle_cast(:sqrt, current_state) do
    { :noreply, :math.sqrt(current_state) }
  end

  def handle_cast({ :add, number }, current_state) do
    { :noreply, current_state + number }
  end

  # Synchronous request
  def handle_call(:result, _, current_state) do
    { :reply, current_state, current_state}
  end

  def terminate(reason, current_state) do
    IO.puts "TERMINATED"
    reason |> IO.inspect
    current_state |> IO.inspect
  end

  def init(init_state) when is_number(init_state) do #when server starts
    "I am started with the #{init_state}"
    { :ok, init_state }
  end

  def init(init_state) when is_number(init_state) do #when server starts
    { :stop, "The initial state is not a number" }
  end

end

{:ok, _ } = Demo.start() |> IO.inspect
Demo.sqrt() |> IO.inspect
Demo.add(10) |> IO.inspect
Demo.result() |> IO.inspect
