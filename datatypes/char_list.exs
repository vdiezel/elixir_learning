list = 'HI' # character list
IO.inspect list

# also prints HI
IO.inspect [72, 73]
~c(hi)
~C(hi) # no interpolation

# in general, avoid them in favor of binary strings
List.toString(list) # conversion to binary
String.to_charlist("HI") # other way around
