defmodule Aoc2020.Day14 do
  defstruct [:mask, :instructions]

  def parse!(lines, part) do
    parse_line_fn =
      case part do
        :part1 -> &parse_instruction/1
        :part2 -> &parse_instruction2/1
      end

    Enum.map(lines, fn line ->
      line
      |> String.codepoints()
      |> parse_line_fn.()
    end)
  end

  def parse_instruction(["m", "a", "s", "k", " ", "=", " " | val]) do
    map =
      val
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.reject(fn {elem, _index} -> elem == "X" end)
      |> Enum.into(%{}, fn {elem, index} ->
        if elem == "X" do
          {index, elem}
        else
          {index, String.to_integer(elem)}
        end
      end)

    %{op: :mask, val: map}
  end

  def parse_instruction(mem) do
    line = Enum.join(mem)
    [op, val] = String.split(line, " = ")
    [op, index] = String.split(op, "[")

    %{
      op: String.to_atom(op),
      i: index |> String.replace("]", "") |> String.to_integer(),
      val: String.to_integer(val)
    }
  end

  def parse_instruction2(["m", "a", "s", "k", " ", "=", " " | val]) do
    map =
      val
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.into(%{}, fn {elem, index} ->
        if elem == "X" do
          {index, elem}
        else
          {index, String.to_integer(elem)}
        end
      end)

    %{op: :mask, val: map}
  end

  def parse_instruction2(mem) do
    parse_instruction(mem)
  end

  def execute(instructions, part) do
    run_fn =
      case part do
        :part1 -> &run_instruction/3
        :part2 -> &run_instruction2/3
      end

    {mem, _mask} =
      Enum.reduce(instructions, {%{}, %{}}, fn instruction, {mem, mask} ->
        run_fn.(instruction, mem, mask)
      end)

    mem
  end

  def mask_to_string(mask_map) do
    Enum.reduce(35..0, "", fn i, acc -> "#{acc}#{Map.get(mask_map, i)}" end)
  end

  def run_instruction2(%{op: :mask} = instruction, mem, _mask) do
    IO.puts("Setting mask: #{mask_to_string(instruction.val)}")
    {mem, instruction.val}
  end

  def run_instruction2(%{op: :mem} = instruction, mem, mask) do
    IO.puts("Running instruction: #{instruction.i}")

    result =
      instruction.i
      |> binary_map()
      |> apply_mask2(mask)

    result_size = map_size(result)

    new_mem =
      result
      |> build_tree()
      |> paths([])
      |> Enum.chunk_by(fn node -> node == nil end)
      |> Enum.reject(fn x ->
        length(x) != result_size
      end)
      |> Enum.into(%{}, fn {:ok, path} ->
        key =
          Enum.with_index(path)
          |> Enum.into(%{}, fn {elem, index} -> {index, elem} end)
          |> to_decimal()

        {key, instruction.val}
      end)

    {Map.merge(mem, new_mem), mask}
  end

  defp build_tree(mask_on_address_map) do
    Enum.reduce(mask_on_address_map, tree(), fn {_k, v}, acc ->
      add(acc, v)
    end)
  end

  def apply_mask2(bin_map, mask_map) do
    Enum.reduce(0..(map_size(mask_map) - 1), %{}, fn i, acc ->
      case Map.get(mask_map, i) do
        0 -> Map.put(acc, i, Map.get(bin_map, i, 0))
        other -> Map.put(acc, i, other)
      end
    end)
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
    binary_val = binary_map(value)

    Map.merge(binary_val, mask)
    |> to_decimal()
  end

  def to_decimal(bin_map) do
    Enum.reduce(bin_map, 0, fn {index, val}, acc ->
      new_val = round(:math.pow(2, index)) * val
      result = acc + new_val
      result
    end)
  end

  def binary_map(decimal) do
    decimal
    |> Integer.digits(2)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.into(%{}, fn {elem, index} -> {index, elem} end)
  end

  def sum_memory(mem) do
    mem
    |> Map.values()
    |> Enum.sum()
  end

  def tree(), do: %{val: nil, left: nil, right: nil}
  def tree(val), do: %{val: val, left: nil, right: nil}

  def add(%{val: _, left: nil, right: nil} = node, "X") do
    %{node | left: tree(0), right: tree(1)}
  end

  def add(%{val: _, left: nil, right: r} = node, "X") do
    %{node | left: tree(0), right: add(r, "X")}
  end

  def add(%{val: _, left: l, right: nil} = node, "X") do
    %{node | left: add(l, "X"), right: tree(1)}
  end

  def add(%{val: _, left: l, right: r} = node, "X") do
    %{node | left: add(l, "X"), right: add(r, "X")}
  end

  def add(%{val: _, left: nil, right: nil} = node, 0) do
    %{node | left: tree(0)}
  end

  def add(%{val: _, left: nil, right: r} = node, 0) do
    %{node | right: add(r, 0)}
  end

  def add(%{val: _, left: l, right: nil} = node, 0) do
    %{node | left: add(l, 0)}
  end

  def add(%{val: _, left: l, right: r} = node, 0) do
    %{node | left: add(l, 0), right: add(r, 0)}
  end

  def add(%{val: _, left: nil, right: nil} = node, 1) do
    %{node | right: tree(1)}
  end

  def add(%{val: _, left: nil, right: r} = node, 1) do
    %{node | right: add(r, 1)}
  end

  def add(%{val: _, left: l, right: nil} = node, 1) do
    %{node | left: add(l, 1)}
  end

  def add(%{val: _, left: l, right: r} = node, 1) do
    %{node | left: add(l, 1), right: add(r, 1)}
  end

  def paths(%{val: val, left: nil, right: nil}, acc), do: Enum.reverse([val | acc])

  def paths(%{val: val, left: nil, right: r}, acc) do
    paths(r, [val | acc])
  end

  def paths(%{val: val, left: l, right: nil}, acc) do
    paths(l, [val | acc])
  end

  def paths(%{val: val, left: l, right: r}, acc) do
    [
      paths(l, [val | acc]),
      paths(r, [val | acc])
    ]
    |> List.flatten()
  end
end
