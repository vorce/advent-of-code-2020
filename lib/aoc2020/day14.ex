defmodule Aoc2020.Day14 do
  defstruct [:mask, :instructions]

  def parse!([mask | instructions]) do
    instructions = Enum.map(instructions, &parse_instruction/1)
    # mask =
    mask =
      mask
      |> String.codepoints()
      |> Enum.drop(7)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reject(fn {elem, _index} -> elem == "X" end)
      |> Enum.into(%{}, fn {elem, index} -> {index, String.to_integer(elem)} end)

    %__MODULE__{mask: mask, instructions: instructions}
  end

  def parse_instruction(line) do
    # mem[8] = 11
    [op, val] = String.split(line, " = ")
    [op, index] = String.split(op, "[")

    %{
      op: String.to_atom(op),
      i: index |> String.replace("]", "") |> String.to_integer(),
      val: String.to_integer(val)
    }
  end

  def execute(prog) do
    Enum.reduce(prog.instructions, %{}, fn instruction, acc ->
      run_instruction(instruction, acc, prog.mask)
    end)
  end

  def run_instruction(instruction, acc, mask) do
    new_val = apply_mask(instruction.val, mask)

    if new_val != 0 do
      Map.put(acc, instruction.i, new_val)
    else
      acc
    end
  end

  def apply_mask(value, mask) do
    # Integer.digits(11, 2)
    # [1, 0, 1, 1]
    binary_val =
      Integer.digits(value, 2)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.into(%{}, fn {elem, index} -> {index, elem} end)

    Map.merge(binary_val, mask)
    |> Enum.reduce(0, fn {index, val}, acc ->
      new_val = round(:math.pow(2, index)) * val
      result = acc + new_val
      result
    end)
  end

  def sum_memory(mem) do
    mem
    |> Map.values()
    |> Enum.sum()
  end
end
