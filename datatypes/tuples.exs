tuple = {:ok, "hi", 10}

# accessing by index
IO.puts elem(tuple, 0)

# setting by index
new_tuple = put_elem(tuple, 2, 5)
IO.inspect new_tuple
