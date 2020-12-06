defmodule AdventOfCode do
  def part1(filename) do
    {:ok, contents} = File.read(filename)

    group_answers = contents
                    |> String.split("\n\n", trim: true)
                    |> Enum.map(fn (group) -> String.split(group, "\n", trim: true) end)

    Enum.map(group_answers, fn answers ->
      answers
      |> Enum.reduce(fn (str, acc) -> acc <> str end)
      |> String.graphemes()
      |> Enum.uniq()
      |> Kernel.length()
    end)
    |> Enum.sum
  end
end


filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part1, [filename])
