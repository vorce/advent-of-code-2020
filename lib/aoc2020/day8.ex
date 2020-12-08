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

  def execute(ins, _pointer, acc, _) when map_size(ins) == 0, do: acc

  def execute(instructions, pointer, acc, done) do
    instruction = Map.get(instructions, pointer)

    # IO.inspect([instruction: instruction, acc: acc, pointer: pointer, done: done],
    #   label: "instruction"
    # )

    if MapSet.member?(done, instruction) do
      acc
    else
      {pointer, acc} = execute_instruction(instruction, pointer, acc)
      execute(instructions, pointer, acc, MapSet.put(done, instruction))
    end
  end

  def execute_instruction(%{op: :nop}, pointer, acc), do: {pointer + 1, acc}
  def execute_instruction(%{op: :acc, arg: i}, pointer, acc), do: {pointer + 1, acc + i}
  def execute_instruction(%{op: :jmp, arg: offset}, pointer, acc), do: {pointer + offset, acc}
end
