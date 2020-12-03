defmodule AdventOfCode do
  def part1(filename) do
    {:ok, contents} = File.read(filename)
    map = String.split(contents, "\n", trim: true)

    numberOfTrees(map, 1, 3)
  end

  def part2(filename) do
    {:ok, contents} = File.read(filename)
    map = String.split(contents, "\n", trim: true)

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn {right_slope, down_slope} ->
      numberOfTrees(map, right_slope, down_slope)
    end)
    |> Enum.reduce(fn a, b -> a * b end)
  end

  def numberOfTrees(map, right_slope, down_slope) do
    pos_x = 0 + right_slope
    pos_y = 0 + down_slope

    Stream.unfold({pos_x, pos_y}, fn {x, y} ->
      case getCords(map, x, y) do
        "#" ->
          {1, {x+right_slope, y+down_slope}}
        "." ->
          {0, {x+right_slope, y+down_slope}}
        _ ->
          nil
      end
    end)
    |> Enum.to_list()
    |> Enum.sum()
  end

  def getCords(map, x, y) do
    row = Enum.at(map, y)

    if row == nil do
      nil
    else
      String.at(row, rem(x, String.length(row)))
    end
  end
end

filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part1, [filename])
IO.inspect :timer.tc(AdventOfCode, :part2, [filename])
