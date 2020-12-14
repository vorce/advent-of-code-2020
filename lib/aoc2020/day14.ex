defmodule Aoc2020.Day14 do
  defstruct [:mask, :instructions]

  def parse!(lines) do
    Enum.map(lines, fn line ->
      line
      |> String.codepoints()
      |> parse_instruction()
    end)
  end

  def parse_instruction(["m", "a", "s", "k", " ", "=", " " | val]) do
    val =
      val
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reject(fn {elem, _index} -> elem == "X" end)
      |> Enum.into(%{}, fn {elem, index} -> {index, String.to_integer(elem)} end)

    %{op: :mask, val: val}
  end

  def parse_instruction(mem) do
    # mem[8] = 11
    line = Enum.join(mem)
    [op, val] = String.split(line, " = ")
    [op, index] = String.split(op, "[")

    %{
      op: String.to_atom(op),
      i: index |> String.replace("]", "") |> String.to_integer(),
      val: String.to_integer(val)
    }
  end

  def execute(instructions) do
    {mem, _mask} =
      Enum.reduce(instructions, {%{}, %{}}, fn instruction, {mem, mask} ->
        run_instruction(instruction, mem, mask)
      end)

    mem
  end

  def run_instruction(%{op: :mem} = instruction, mem, mask) do
    new_val = apply_mask(instruction.val, mask)

    if new_val != 0 do
      {Map.put(mem, instruction.i, new_val), mask}
    else
      {mem, mask}
    end
  end

  def run_instruction(%{op: :mask} = instruction, mem, _mask) do
    {mem, instruction.val}
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
