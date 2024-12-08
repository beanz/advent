input = File.read!(List.first(System.argv, "input.txt"))

defmodule Day03 do
  def part1(s) do
    Regex.scan(~r/mul\((\d+),(\d+)\)/, s)
    |> Enum.map(fn ([_, a, b]) ->
      String.to_integer(a)*String.to_integer(b)
    end)
    |> Enum.sum()
  end

end

input
|> Day03.part1
|> IO.inspect(label: "Part 1")

input
|> String.split(~r"do\(\)")
|> Enum.map(fn (l) -> l
  |> String.split(~r"don't\(\)")
  |> List.first
  |> Day03.part1
end)
|> Enum.sum()
|> IO.inspect(label: "Part 2")

