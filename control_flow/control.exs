def test do
  def run do
    val = 5
    if val == 5, do: "five", else: "not five"
  end

  def run2(str) do
    len = Str.length(str)
    cond do
      len > 0 && len < 5 -> "short"
      len >= 5 && len < 10 -> "middle"
      len > 10 -> "long"
      true -> "an empty string"
  end

end
