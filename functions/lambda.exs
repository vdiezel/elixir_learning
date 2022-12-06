# mad_printer = fn
#   ("") -> IO.puts("__NOVAL__") # multiple binding for lambda
#   (initial_string) ->
#   |> String.reverse
#   |> IO.puts
# end

mad_printer = &(
  &1
  |> String.reverse
  |> IO.puts
)

mad_printer.("Hello there friend") # mind the DOT!

list = ["hello", "my", "frined"]

Enum.each(list, mad_printer)
Enum.each(list, &IO.puts/1) # turns the function into a lambda
