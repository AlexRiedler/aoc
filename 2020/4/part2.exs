defmodule AdventOfCode do
  def part2(filename) do
    {:ok, contents} = File.read(filename)
    required_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
    field_tests =
      %{
        "byr" => fn (year_str) ->
          {year, ""} = Integer.parse(year_str)
          year >= 1920 && year <= 2002
        end,
        "iyr" => fn (year_str) ->
          {year, ""} = Integer.parse(year_str)
          year >= 2010 && year <= 2020
        end,
        "eyr" => fn (year_str) ->
          {year, ""} = Integer.parse(year_str)
          year >= 2020 && year <= 2030
        end,
        "hgt" => fn (height_str) ->
          case Integer.parse(height_str) do
            {height, "cm"} -> height >= 150 && height <= 193
            {height, "in"} -> height >= 59 && height <= 76
            _ -> false
          end
        end,
        "hcl" => fn (hair_color_str) ->
          String.match?(hair_color_str, ~r/\A\#[0-9a-f]{6}\Z/)
        end,
        "ecl" => fn (eye_color_str) ->
          String.match?(eye_color_str, ~r/\A(amb|blu|brn|gry|grn|hzl|oth)\Z/)
        end,
        "pid" => fn (passport_id) ->
          String.match?(passport_id, ~r/\A[0-9]{9}\Z/)
        end,
        "cid" => fn (_) -> true end
      }

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
          validation_func = Map.get(field_tests, required_key, fn (_) -> false end)
          acc && Map.has_key?(fields, required_key) && apply(validation_func, [Map.get(fields, required_key)])
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
IO.inspect :timer.tc(AdventOfCode, :part2, [filename])
