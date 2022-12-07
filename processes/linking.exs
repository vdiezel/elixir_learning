defmodule Demo do
  def work do
    IO.puts "Doing work"
    exit :error
  end

  def run do
    Process.flag :trap_exit, true
    spawn_link fn -> work() end

    receive do
      response -> IO.inspect response
    end

    IO.puts "doing something else..."
  end
end

Demo.run
