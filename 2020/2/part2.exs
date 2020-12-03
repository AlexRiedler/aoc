defmodule AdventOfCode do
  def part2(filename) do
    {:ok, contents} = File.read(filename)

    policies = contents |> String.split("\n", trim: true) |> Enum.map(fn (line) -> String.split(line, " ") end)

    Enum.count(policies, fn [range, char, password] ->
      [{lower, ""}, {upper, ""}] = String.split(range, "-") |> Enum.map(&Integer.parse/1)
      grapheme = String.at(char, 0)

      lower_ch = String.at(password, lower - 1)
      upper_ch = String.at(password, upper - 1)

      (lower_ch == grapheme || upper_ch == grapheme) && lower_ch != upper_ch
    end)
  end
end

filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part2, [filename])
