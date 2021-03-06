defmodule GameConsole do
  use GenServer

  def start_link(instructions) do
    GenServer.start_link(__MODULE__, instructions)
  end

  def accumulator(server) do
    GenServer.call(server, {:accumulator})
  end

  def program_counter(server) do
    GenServer.call(server, {:program_counter})
  end

  def step_program(server) do
    GenServer.call(server, {:step_program, false})
  end

  def step_program(server, invert) do
    GenServer.call(server, {:step_program, invert})
  end

  @impl true
  def init(instructions) do
    {:ok, {0, instructions, 0}}
  end

  @impl true
  def handle_call({:accumulator}, _from, {pc, instructions, accumulator}) do
    {:reply, accumulator, {pc, instructions, accumulator}}
  end

  @impl true
  def handle_call({:program_counter}, _from, {pc, instructions, accumulator}) do
    {:reply, pc, {pc, instructions, accumulator}}
  end

  @impl true
  def handle_call({:step_program, invert}, _from, {pc, instructions, accumulator}) do
    if invert do
      case Enum.at(instructions, pc) do
        {"nop", offset} ->
          {:reply, pc, {pc + offset, instructions, accumulator}}
        {"acc", offset} ->
          {:reply, pc, {pc + 1, instructions, accumulator + offset}}
        {"jmp", offset} ->
          {:reply, pc, {pc + 1, instructions, accumulator}}
        nil ->
          IO.inspect("WOOPS: #{accumulator}")
      end
    else
      case Enum.at(instructions, pc) do
        {"nop", offset} ->
          {:reply, pc, {pc + 1, instructions, accumulator}}
        {"acc", offset} ->
          {:reply, pc, {pc + 1, instructions, accumulator + offset}}
        {"jmp", offset} ->
          {:reply, pc, {pc + offset, instructions, accumulator}}
        nil ->
          IO.inspect("WOOPS: #{accumulator}")
      end
    end
  end
end

defmodule AdventOfCode do
  def part2(filename) do
    {:ok, contents} = File.read(filename)

    instructions = contents
                |> String.split("\n", trim: true)
                |> Enum.map(fn (instr) -> String.split(instr, " ", trim: true) end)
                |> Enum.map(fn [instr_code, offset] ->
                  {offset_num, ""} = Integer.parse(offset)
                  {instr_code, offset_num}
                end)

    Enum.map(0..length(instructions), fn (idx) ->
      {:ok, game_console} = GameConsole.start_link(instructions)

      Stream.unfold(MapSet.new(), fn (set) ->
        if MapSet.member?(set, GameConsole.program_counter(game_console)) do
          nil # infinite loop, break
        else
          pc = GameConsole.step_program(game_console, GameConsole.program_counter(game_console) == idx)
          next_pc = GameConsole.program_counter(game_console)

          if next_pc == length(instructions) do
            nil # found a solution that reaches the end code
          else
            {{pc, Enum.at(instructions, pc), GameConsole.accumulator(game_console)}, MapSet.put(set, pc)}
          end
        end
      end)
      |> Enum.to_list()

      {GameConsole.program_counter(game_console), GameConsole.accumulator(game_console)}
    end)
    |> Enum.filter(fn {pc, _acc} -> pc == length(instructions) end)
  end
end


filename = Enum.at(System.argv, 0)
IO.inspect :timer.tc(AdventOfCode, :part2, [filename])
