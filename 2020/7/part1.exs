defmodule AdventOfCode do
  def part1(filename) do
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

    Stream.unfold({ MapSet.new(), ["shiny gold bag"] }, fn {bags, bag_types} ->
      all_seen_bags =
        Enum.reduce(bag_types, bags, fn (bag_type, seen_bags) ->
          MapSet.union(seen_bags, find_rules_containing_bag_type(bag_rules, bag_type))
        end)

      if MapSet.size(MapSet.difference(all_seen_bags, bags)) > 0 do
        {all_seen_bags, {all_seen_bags, MapSet.difference(all_seen_bags, bags)}}
      else
        nil
      end
    end)
    |> Enum.to_list()
    |> List.last()
    |> MapSet.size()
  end

  def find_rules_containing_bag_type(bag_rules, expected_bag_type) do
    Enum.reduce(bag_rules, MapSet.new(), fn ({bag_type, contents}, new_bag_types) ->
      contains_expected_bag_type =
        Enum.reduce(contents, false, fn ([_, bag_color], acc) ->
          acc || bag_color == expected_bag_type
        end)

      if contains_expected_bag_type do
        MapSet.put(new_bag_types, bag_type)
      else
        new_bag_types
      end
    end)
  end
end


filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part1, [filename])
