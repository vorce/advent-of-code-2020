defmodule Aoc2020.Day12 do
  defstruct [:ew, :ns, :direction]

  def parse!(inp) do
    inp
    |> Enum.map(&String.codepoints/1)
    |> Enum.map(&parse_command/1)
  end

  def parse_command([cmd | rest]) do
    val = rest |> Enum.join() |> String.to_integer()
    {cmd, val}
  end

  def manhattan_distance(instructions) do
    start = %__MODULE__{ew: 0, ns: 0, direction: :east}

    end_state =
      Enum.reduce(instructions, start, fn instruction, acc ->
        apply_instruction(acc, instruction)
        |> IO.inspect(label: "new_state for #{inspect(instruction)}")
      end)

    abs(end_state.ew) + abs(end_state.ns)
  end

  def apply_instruction(state, {"F", val}) do
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

  def apply_instruction(state, {"N", val}) do
    %__MODULE__{state | ns: state.ns + val}
  end

  def apply_instruction(state, {"S", val}) do
    %__MODULE__{state | ns: state.ns - val}
  end

  def apply_instruction(state, {"E", val}) do
    %__MODULE__{state | ew: state.ew + val}
  end

  def apply_instruction(state, {"W", val}) do
    %__MODULE__{state | ew: state.ew - val}
  end

  def apply_instruction(state, {"R", 90}) do
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

  def apply_instruction(state, {"L", 90}) do
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

  def apply_instruction(state, {cmd, more}) when cmd in ["L", "R"] do
    rotations = div(more, 90)

    Enum.reduce(1..rotations, state, fn _, acc ->
      apply_instruction(acc, {cmd, 90})
    end)
  end
end
