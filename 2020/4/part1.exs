defmodule AdventOfCode do
  def part1(filename) do
    {:ok, contents} = File.read(filename)
    required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    field_pattern = :binary.compile_pattern([" ", "\n"])
    passports = contents
          |> String.split("\n\n", trim: true)
          |> Enum.map(fn (passport) -> String.split(passport, field_pattern, trim: true) end)

    Enum.map(passports, fn (passport) ->
      fields = Enum.reduce(passport, %{}, fn (field, acc) ->
        [field, value] = String.split(field, ":", trim: true)
        Map.put(acc, field, value)
      end)

      has_required_fields =
        Enum.reduce(required_fields, true, fn (required_key, acc) ->
          acc && Map.has_key?(fields, required_key)
        end)

      if has_required_fields do
        1
      else
        0
      end
    end)
    |> Enum.sum()
  end

end

filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part1, [filename])
