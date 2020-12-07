defmodule AdventOfCode do
  def part2(filename) do
    {:ok, contents} = File.read(filename)

    bag_rules = contents
                |> String.replace("bags", "bag")
                |> String.replace(".", "")
                |> String.replace(" no ", " 0 ")
                |> String.split("\n", trim: true)
                |> Enum.map(fn (group) -> String.split(group, " contain ", trim: true) end)
                |> Enum.map(fn [bag, contents] ->
                  {
                    bag,
                    String.split(contents, ", ", trim: true) |> Enum.map(fn (a) -> String.split(a, " ", parts: 2) end)
                  }
                end)
                |> Map.new

    find_minimum_enclosed_bags(bag_rules, "shiny gold bag")
  end

  def find_minimum_enclosed_bags(bag_rules, bag_type) do
    Enum.reduce(bag_rules[bag_type], 0, fn ([count, enclosed_bag_type], acc) ->
      {cnt, ""} = Integer.parse(count)
      if cnt == 0 do
        acc
      else
        acc + cnt * (1 + find_minimum_enclosed_bags(bag_rules, enclosed_bag_type))
      end
    end)
  end
end


filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part2, [filename])
