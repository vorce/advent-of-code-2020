defmodule Aoc2020.Day8 do
  @moduledoc """
  8
  """

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

  def execute(ins, pointer, acc, _) when map_size(ins) == 0, do: {pointer, acc}
  def execute(ins, pointer, acc, _) when pointer >= map_size(ins), do: {pointer, acc}

  def execute(instructions, pointer, acc, done) do
    instruction = Map.get(instructions, pointer)

    if MapSet.member?(done, instruction) do
      {pointer, acc}
    else
      {pointer, acc} = execute_instruction(instruction, pointer, acc)
      execute(instructions, pointer, acc, MapSet.put(done, instruction))
    end
  end

  def execute_instruction(%{op: :nop}, pointer, acc), do: {pointer + 1, acc}
  def execute_instruction(%{op: :acc, arg: i}, pointer, acc), do: {pointer + 1, acc + i}
  def execute_instruction(%{op: :jmp, arg: offset}, pointer, acc), do: {pointer + offset, acc}

  def fix_loops(instructions, pointer, acc) do
    {pointer, acc} = fix_loop(instructions, pointer, acc, :jmp)

    if pointer >= map_size(instructions) do
      {pointer, acc}
    else
      fix_loop(instructions, pointer, acc, :nop)
    end
  end

  def fix_loop(instructions, pointer, acc, op) do
    case Map.get(instructions, pointer) do
      nil ->
        {pointer, acc}

      %{op: ^op} = ins ->
        new_op = swap_instruction(ins)
        {exec_pointer, acc} = execute(Map.put(instructions, pointer, new_op), 0, 0, MapSet.new())

        if exec_pointer >= map_size(instructions) do
          {exec_pointer, acc}
        else
          fix_loop(instructions, pointer + 1, acc, :jmp)
        end

      _ ->
        fix_loop(instructions, pointer + 1, acc, :jmp)
    end
  end

  defp swap_instruction(%{op: :jmp} = op) do
    %{op | op: :nop}
  end

  defp swap_instruction(%{op: :nop} = op) do
    %{op | op: :jmp}
  end
end
