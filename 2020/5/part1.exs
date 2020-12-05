defmodule AdventOfCode do
  def part1(filename) do
    {:ok, contents} = File.read(filename)

    tickets = contents
              |> String.split("\n", trim: true)
              |> Enum.map(fn (ticket) -> String.split_at(ticket, 7) end)

    Enum.map(tickets, fn {row, column} ->
      row_data = String.graphemes(row)
      column_data = String.graphemes(column)

      {bsp(row_data, 0..127, "B", "F"), bsp(column_data, 0..7, "R", "L")}
    end)
    |> Enum.map(fn {[x], [y]} -> 8 * x + y end)
    |> Enum.max
  end

  def bsp(data, range, upper, lower) do
    space = Enum.map(range, fn (i) -> i end)
    Enum.reduce(data, space, fn (elem, acc) ->
      {lower_space, upper_space} = Enum.split(acc, ceil(length(acc)/2))
      if elem == upper do
        upper_space
      else
        lower_space
      end
    end)
  end
end


filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part1, [filename])
