defmodule Aoc2020.Day8 do
  @moduledoc """
  8
  """

  defstruct [:acc, :pointer]

  def parse!(input) do
    input
    |> Enum.with_index()
    |> Enum.into(%{}, &parse_line/1)
  end

  def parse_line({line, index}) do
    [operator, argument] = String.split(line, " ")

    case Integer.parse(argument) do
      {int, ""} -> {index, %{op: String.to_atom(operator), arg: int, line: index}}
      _ -> %{}
    end
  end

  def execute(ins, %__MODULE__{} = state, _) when map_size(ins) == 0, do: state

  def execute(ins, %__MODULE__{pointer: p} = state, _) when p >= map_size(ins), do: state

  def execute(instructions, %__MODULE__{} = state, done) do
    instruction = Map.get(instructions, state.pointer)

    if MapSet.member?(done, instruction) do
      state
    else
      new_state = execute_instruction(instruction, state)
      execute(instructions, new_state, MapSet.put(done, instruction))
    end
  end

  def execute_instruction(%{op: :nop}, %__MODULE__{} = state),
    do: %__MODULE__{state | pointer: state.pointer + 1}

  def execute_instruction(%{op: :acc, arg: i}, %__MODULE__{} = state),
    do: %__MODULE__{state | pointer: state.pointer + 1, acc: state.acc + i}

  def execute_instruction(%{op: :jmp, arg: offset}, %__MODULE__{} = state),
    do: %__MODULE__{state | pointer: state.pointer + offset}

  def fix_loops(instructions, state) do
    state = fix_loop(instructions, state, :jmp)

    if state.pointer >= map_size(instructions) do
      state
    else
      fix_loop(instructions, state, :nop)
    end
  end

  def fix_loop(instructions, state, op) do
    case Map.get(instructions, state.pointer) do
      nil ->
        state

      %{op: ^op} = ins ->
        new_op = swap_instruction(ins)

        exec_state =
          execute(
            Map.put(instructions, state.pointer, new_op),
            %__MODULE__{acc: 0, pointer: 0},
            MapSet.new()
          )

        if exec_state.pointer >= map_size(instructions) do
          exec_state
        else
          fix_loop(instructions, %__MODULE__{state | pointer: state.pointer + 1}, op)
        end

      _ ->
        fix_loop(instructions, %__MODULE__{state | pointer: state.pointer + 1}, op)
    end
  end

  defp swap_instruction(%{op: :jmp} = op) do
    %{op | op: :nop}
  end

  defp swap_instruction(%{op: :nop} = op) do
    %{op | op: :jmp}
  end
end
