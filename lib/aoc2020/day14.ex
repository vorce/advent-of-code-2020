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
    map =
      val
      |> Enum.reverse()
      |> Enum.with_index()
      # |> Enum.reject(fn {elem, _index} -> elem == "X" end)
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

  def execute2(instructions) do
    {mem, _mask} =
      Enum.reduce(instructions, {%{}, %{}}, fn instruction, {mem, mask} ->
        run_instruction2(instruction, mem, mask)
      end)

    mem
  end

  def mask_to_string(mask_map) do
    Enum.reduce(35..0, "", fn i, acc -> "#{acc}#{Map.get(mask_map, i)}" end)
  end

  def run_instruction2(%{op: :mask} = instruction, mem, _mask) do
    {mem, instruction.val}
  end

  def run_instruction2(%{op: :mem} = instruction, mem, mask) do
    # IO.inspect(binding(), label: "Setting mem")

    result =
      instruction.i
      |> binary_map()
      |> apply_mask2(mask)

    result_size = map_size(result)

    new_mem =
      Enum.reduce(result, tree(), fn {_k, v}, acc ->
        add(acc, v)
      end)
      |> paths([])
      |> Enum.chunk_by(fn x -> x == nil end)
      |> Enum.reject(fn x ->
        res = length(x) != result_size
        res
      end)
      |> Enum.into(%{}, fn path ->
        key =
          Enum.with_index(path)
          |> Enum.into(%{}, fn {elem, index} -> {index, elem} end)
          |> to_decimal()

        {key, instruction.val}
      end)

    # |> IO.inspect(label: "write to mem")

    {Map.merge(mem, new_mem), mask}
  end

  def apply_mask2(bin_map, mask_map) do
    Enum.reduce(0..(map_size(mask_map) - 1), %{}, fn i, acc ->
      case Map.get(mask_map, i) do
        0 -> Map.put(acc, i, Map.get(bin_map, i, 0))
        other -> Map.put(acc, i, other)
      end
    end)
  end

  # %{1 => "X", 2 => 1, 3 => "X"} => %{1 => 1, 2 => 1, 3 => 1}, %{1 => 0, 2 => 1, 3 => 1}, %{1 => 1, 2 => 1, 3 => 0}, %{1 => 0, 2 => 1, 3 => 0}
  # %{1 => "X", 2 => 1, 3 => "X"}. %{2 => 1, 3 => "X"}, [%{1 => 0, 2 => 1, 3 => "X"}, %{1 => 1, 2 => 1, 3 => "X"}]
  # def expand_floating(map, acc) when map_size(map) == 0, do: acc

  # def expand_floating(map, acc) do
  #   IO.inspect(binding(), label: "expand_floating")
  #   has_floating? = Map.values(map) |> Enum.any?(fn val -> val == "X" end)

  #   if has_floating? do
  #     Enum.reduce(map, acc, fn {k, v}, sub_acc ->
  #       if v == "X" do
  #         IO.inspect([k: k, v: v], label: "found X")
  #         # without_k = Map.drop(map, [k])
  #         expand_floating(Map.drop(map, [k]), sub_acc)
  #         |> Enum.flat_map(fn m ->
  #           [Map.put(m, k, 0), Map.put(m, k, 1) | sub_acc]
  #         end)
  #         |> IO.inspect(label: "result")
  #       else
  #         sub_acc
  #       end
  #     end)
  #   else
  #     acc
  #   end
  # end

  # def expand_floating(map, acc) when map_size(map) == 0, do: acc

  # def expand_floating(map, acc) when map_size(map) == 1 do
  #   [val] = Map.values(map)

  #   if val == "X" do
  #     [key] = Map.keys(map)
  #     [Map.put(map, key, 1), Map.put(map, key, 0)]
  #   else
  #     [map | acc]
  #   end
  # end

  # def expand_floating(map, acc) do
  #   has_floating? = Enum.any?(map, fn {_k, v} -> v == "X" end)

  #   if has_floating? do
  #     do_expand_floating(map, acc)
  #   else
  #     acc
  #   end
  # end

  # %{0 => X, 1 => 1}
  # 1: %{0 => 0, 1 => 1}, [] ->
  # def do_expand_floating(map, acc) do
  #   IO.inspect(binding(), label: "expand_floating")

  #   Enum.reduce(map, acc, fn {k, v}, sub ->
  #     if v == "X" do
  #       without_k = Map.drop(map, [k])

  #       new_sub_acc =
  #         Enum.reduce(sub, [], fn m, ss ->
  #           [Map.merge(m, Map.put(without_k, k, 0)), Map.merge(m, Map.put(without_k, k, 1)) | ss]
  #         end)
  #         |> IO.inspect(label: "new_sub_acc")

  #       expand_floating(without_k, new_sub_acc)
  #       |> IO.inspect(label: "result")
  #     else
  #       sub |> IO.inspect(label: "sub when not a floating")
  #     end
  #   end)
  # end

  # %{0=>X} -> [%{0 => 0}, %{0 => 1}]
  def float_combs(map, acc) when map_size(map) == 0 do
    Enum.reverse(acc)
  end

  def float_combs(map, acc) do
    IO.inspect(binding(), label: "float_combs")

    Enum.reduce(map, acc, fn {k, v}, sub ->
      if v == "X" do
        float_combs(Map.drop(map, [k]), [Map.put(map, k, 0), Map.put(map, k, 1) | sub])
        # res = float_combs(Map.drop(map, [k]), sub)
        # [Map.put(map, k, 0), Map.put(map, k, 1) | sub])
      else
        sub
      end
    end)
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])

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

  # "X1101X" => ["011010", "011011", "111010", "111011"]
  # sub problem: "X1101X" => ["01101X", "11101X"]
  def foo(s) do
    map =
      s
      |> String.codepoints()
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.into(%{}, fn {elem, index} -> {index, elem} end)

    Enum.reduce(map, [], fn {k, v}, acc ->
      if v == "X" do
        [Map.put(map, k, "0"), Map.put(map, k, "1") | acc]
      else
        acc
      end
    end)
    # |> IO.inspect(label: "reduced")
    |> Enum.map(fn m ->
      Enum.reduce(m, "", fn {_k, v}, acc -> acc <> v end)
    end)
  end

  def expand(map, pos, orig_map) when is_map(map) do
    Enum.reduce_while(map, [], fn {k, v}, acc ->
      if v == "X" and k >= pos do
        {:halt, {k + 1, [Map.put(map, k, 0), Map.put(map, k, 1) | acc]}}
      else
        {:cont, acc}
      end
    end)
  end

  def expand(maps, pos, orig_map) when is_list(maps) do
    Enum.reduce(maps, {pos, []}, fn map, {p, acc} ->
      case expand(map, 1, map) do
        {np, res} ->
          {np, [res | acc]}

        _res ->
          {p + 1, acc}
      end
    end)
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
