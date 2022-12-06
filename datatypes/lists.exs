list = [1, "hi", :atom]

# like arrays - but they are operated on like on a linked list (recursively),
# so not great for random access
IO.puts lenght(list)
IO.puts Enum.at(list, 1)

# head
IO.puts hd(list)
IO.inspect tl(list)

IO.inspect [1 | [ 2 | [ 3 | [] ] ] ]
list = [ 100 | list ] # cheap; adding to the end is expensive
