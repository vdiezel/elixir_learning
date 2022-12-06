value = %{"language" => "Elixir", "platform" => "OTP"}
value = %{ language: "Elixir", platform: "OTP" }

# access
IO.puts value[:language]
IO.put value.platform
IO.inspect value[:non_existent]

# this will throw!
# IO.inspect value.non_existent

# updating
new_value = %{ value | language: "Erlang", platform: "IDK" }
IO.inspect new_value
