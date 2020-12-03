defmodule AdventOfCode do
  def part1(filename) do
    {:ok, contents} = File.read(filename)

    policies = contents |> String.split("\n", trim: true) |> Enum.map(fn (line) -> String.split(line, " ") end)

    Enum.count(policies, fn [range, char, password] ->
      [{lower, ""}, {upper, ""}] = String.split(range, "-") |> Enum.map(&Integer.parse/1)
      grapheme = String.at(char, 0)
      password_graphemes =String.graphemes(password)
      grapheme_count = Enum.count(password_graphemes, fn (g) -> grapheme == g end)

      grapheme_count >= lower && grapheme_count <= upper
    end)
  end
end

filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part1, [filename])
