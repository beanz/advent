input = File.stream!(List.first(System.argv, "input.txt"))
|> Stream.map(&String.trim/1)
|> Stream.map(fn (l) -> l
  |> String.split()
  |> Enum.map(&String.to_integer/1)
end)
|> Stream.map(&List.to_tuple/1)
|> Enum.unzip()
|> Tuple.to_list
|> Enum.map(&Enum.sort/1)
input
|> Enum.zip()
|> Enum.reduce(0, fn {a,b}, acc -> abs(a-b) + acc end)
|> IO.inspect(label: "Part 1")

defmodule Day01 do
  def part2([[],[]], acc, ca, cb, v) do
      acc+ca*cb*v
  end
  def part2([[],_], acc, _, _, -1) do
    acc
  end
  def part2([_,[]], acc, _, _, -1) do
    acc
  end
  def part2([[],b], acc, ca, cb, v) do
    if hd(b) == v do
      part2([[], tl(b)], acc, ca, cb+1, v)
    else
      part2([[], b], acc+v*ca*cb, 0, 0, -1)
    end
  end
  def part2([a,[]], acc, ca, cb, v) do
    if hd(a) == v do
      part2([tl(a), []], acc, ca+1, cb, v)
    else
      part2([a, []], acc+v*ca*cb, 0, 0, -1)
    end
  end
  def part2([a,b], acc, 0, 0, -1) do
    if hd(a) < hd(b) do
      part2([tl(a), b], acc, 0, 0, -1)
    else
      if hd(b) < hd(a) do
        part2([a, tl(b)], acc, 0, 0, -1)
      else
        part2([tl(a), b], acc, 1, 0, hd(a))
      end
    end
  end
  def part2([a,b], acc, ca, cb, v) do
    if hd(a) == v do
      part2([tl(a), b], acc, ca+1, cb, v)
    else
      if hd(b) == v do
        part2([a, tl(b)], acc, ca, cb+1, v)
      else
        part2([a, b], acc+v*ca*cb, 0, 0, -1)
      end
    end
  end
end

input
|> Day01.part2(0, 0, 0, -1)
|> IO.inspect(label: "Part 2")
