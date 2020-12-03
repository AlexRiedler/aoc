filename = Enum.at(System.argv, 0)
{:ok, contents} = File.read(filename)

entries = contents |> String.split("\n", trim: true) |> Enum.map(&Integer.parse/1) |> Enum.map(fn {int, _} -> int end)

Enum.map(entries, fn (entry_a) ->
  Enum.map(entries, fn (entry_b) ->
    Enum.map(entries, fn (entry_c) ->
      if (entry_a + entry_b + entry_c == 2020) do
        IO.puts "#{entry_a * entry_b * entry_c}"
      end
    end)
  end)
end)
