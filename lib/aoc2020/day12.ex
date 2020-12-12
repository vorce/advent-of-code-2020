defmodule Aoc2020.Day12 do
  defstruct [:ew, :ns, :direction, :waypoint]

  def parse!(inp) do
    inp
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&parse_command/1)
  end

  def parse_command([cmd | rest]) do
    val = rest |> Enum.join() |> String.to_integer()
    {cmd, val}
  end

  def manhattan_distance(instructions, instruction_interpreter) do
    waypoint = %{ew: 10, ns: 1}
    ship = %__MODULE__{ew: 0, ns: 0, direction: :east, waypoint: waypoint}

    instruction_fn =
      case instruction_interpreter do
        :part1 -> &part1_instruction/2
        :part2 -> &part2_instruction/2
      end

    end_state =
      Enum.reduce(instructions, ship, fn instruction, acc ->
        instruction_fn.(acc, instruction)
      end)

    abs(end_state.ew) + abs(end_state.ns)
  end

  def part1_instruction(state, {"F", val}) do
    case state.direction do
      :east ->
        %__MODULE__{state | ew: state.ew + val}

      :west ->
        %__MODULE__{state | ew: state.ew - val}

      :north ->
        %__MODULE__{state | ns: state.ns + val}

      :south ->
        %__MODULE__{state | ns: state.ns - val}
    end
  end

  def part1_instruction(state, {"N", val}) do
    %__MODULE__{state | ns: state.ns + val}
  end

  def part1_instruction(state, {"S", val}) do
    %__MODULE__{state | ns: state.ns - val}
  end

  def part1_instruction(state, {"E", val}) do
    %__MODULE__{state | ew: state.ew + val}
  end

  def part1_instruction(state, {"W", val}) do
    %__MODULE__{state | ew: state.ew - val}
  end

  def part1_instruction(state, {"R", 90}) do
    case state.direction do
      :east ->
        %__MODULE__{state | direction: :south}

      :west ->
        %__MODULE__{state | direction: :north}

      :north ->
        %__MODULE__{state | direction: :east}

      :south ->
        %__MODULE__{state | direction: :west}
    end
  end

  def part1_instruction(state, {"L", 90}) do
    case state.direction do
      :east ->
        %__MODULE__{state | direction: :north}

      :west ->
        %__MODULE__{state | direction: :south}

      :north ->
        %__MODULE__{state | direction: :west}

      :south ->
        %__MODULE__{state | direction: :east}
    end
  end

  def part1_instruction(state, {cmd, val}) when cmd in ["L", "R"] do
    rotate(state, {cmd, val}, &part1_instruction/2)
  end

  def part2_instruction(state, {"F", val}) do
    %__MODULE__{
      state
      | ew: state.ew + state.waypoint.ew * val,
        ns: state.ns + state.waypoint.ns * val
    }
  end

  def part2_instruction(state, {"N", val}) do
    %__MODULE__{state | waypoint: %{state.waypoint | ns: state.waypoint.ns + val}}
  end

  def part2_instruction(state, {"S", val}) do
    %__MODULE__{state | waypoint: %{state.waypoint | ns: state.waypoint.ns - val}}
  end

  def part2_instruction(state, {"E", val}) do
    %__MODULE__{state | waypoint: %{state.waypoint | ew: state.waypoint.ew + val}}
  end

  def part2_instruction(state, {"W", val}) do
    %__MODULE__{state | waypoint: %{state.waypoint | ew: state.waypoint.ew - val}}
  end

  def part2_instruction(state, {"R", 90}) do
    %__MODULE__{state | waypoint: %{ew: state.waypoint.ns, ns: state.waypoint.ew * -1}}
  end

  def part2_instruction(state, {"L", 90}) do
    %__MODULE__{state | waypoint: %{ew: state.waypoint.ns * -1, ns: state.waypoint.ew}}
  end

  def part2_instruction(state, {cmd, val}) when cmd in ["L", "R"] do
    rotate(state, {cmd, val}, &part2_instruction/2)
  end

  def rotate(state, {cmd, val}, instruction_fn) do
    rotations = div(val, 90)

    Enum.reduce(1..rotations, state, fn _, acc ->
      instruction_fn.(acc, {cmd, 90})
    end)
  end
end
