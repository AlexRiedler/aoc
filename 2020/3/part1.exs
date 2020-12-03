defmodule AdventOfCode do
  def part1() do
    {:ok, contents} = File.read("sample")

    contents
    |> String.split("\n", trim: true)
    |> numberOfTrees(3, 1)
    |> IO.puts
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

AdventOfCode.part1()
IO.inspect :timer.tc(AdventOfCode, :part1, [])
