defmodule AdventOfCode do
  def part2(filename) do
    {:ok, contents} = File.read(filename)

    group_answers = contents
                    |> String.split("\n\n", trim: true)
                    |> Enum.map(fn (group) -> String.split(group, "\n", trim: true) end)

    Enum.map(group_answers, fn answers ->
      group_size = length(answers)

      answers
      |> Enum.reduce(fn (str, acc) -> acc <> str end)
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.filter(fn {_, val} -> val == group_size end)
      |> Kernel.length()
    end)
    |> Enum.sum
  end
end


filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part2, [filename])
