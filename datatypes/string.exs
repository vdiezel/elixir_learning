string = "Hi!" #this is binary!

string = "hi #{2 * 5}"
IO.inspect string
s_sigils = ~s( hi #{2 * 5})
s_int_sigils = ~S( hi #{2 * 5})
IO.inspect s_sigils
IO.inspect s_int_sigils

# concat
s_sigils <> no_int_sigils
