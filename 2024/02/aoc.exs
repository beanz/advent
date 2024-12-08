input = File.stream!(List.first(System.argv, "input.txt"))
  |> Stream.map(&String.trim/1)
  |> Stream.map(fn (l) -> l
    |> String.split()
    |>  Enum.map(&String.to_integer/1)
  end)
  |> Enum.to_list()

defmodule Day02 do

  def safe(l) do
    MapSet.subset?(MapSet.new(l), MapSet.new([1,2,3])) or
    MapSet.subset?(MapSet.new(l), MapSet.new([-1,-2,-3]))
  end

  def diffs(l) do
    [tl(l), (l |> Enum.reverse() |>tl() |> Enum.reverse())]
    |> List.zip()
    |> Enum.map(fn ({a,b}) -> a-b end)
  end

  def all_drop_one(l) do
    for n <- 0..length(l), do: List.delete_at(l, n)
  end

end

input
|> Enum.filter(fn (e) -> e |> Day02.diffs|> Day02.safe end)
|> Enum.count()
|> IO.inspect(label: "Part 1")

input
|> Enum.filter(fn (e) -> e
  |> Day02.all_drop_one
  |> Enum.any?(fn (f) -> f |> Day02.diffs |> Day02.safe end)
end)
|> Enum.count()
|> IO.inspect(label: "Part 2")

