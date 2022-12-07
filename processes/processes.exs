defmodule Demo do
  def work do
    :timer.sleep(5000)
    IO.puts "Result is #{:rand.normal()}"
  end

  def run do
    spawn fn ->
      work()
    end
  end
end

pid = Demo.run
pid |> IO.inspect
IO.puts "do some oter stugg"
