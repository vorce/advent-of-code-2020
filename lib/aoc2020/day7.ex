defmodule Aoc2020.Day7 do
  @moduledoc """
  7
  """

  def parse!(input) do
    Enum.into(input, %{}, &parse_line/1)
  end

  def carry_in(bag, bag_rules, acc) when map_size(bag_rules) == 0, do: acc

  def carry_in(bag, bag_rules, acc) do
    valid_bags =
      bag_rules
      |> Enum.filter(fn {_level1, value} -> Map.has_key?(value, bag) end)
      |> Enum.into(%{})

    # |> IO.inspect(label: "valid bags")

    # |> Enum.reduce(MapSet.new(), fn {bag, _contains}, acc -> MapSet.put(acc, bag) end)

    # level2_bags =
    #   bag_rules
    #   |> Enum.filter(fn {_level1, value} ->
    #     bag_within?(value, level1_bags)
    #   end)
    #   |> Enum.reduce(MapSet.new(), fn {bag, _contains}, acc -> MapSet.put(acc, bag) end)

    # MapSet.union(level1_bags, level2_bags)
    next_level =
      Enum.filter(bag_rules, fn {_k, value} -> bag_within?(value, valid_bags) end)
      |> Enum.into(%{})

    # |> IO.inspect(label: "next level")

    acc = Map.keys(valid_bags) ++ Map.keys(next_level) ++ acc

    carry_in(
      bag,
      next_level,
      acc
    )
  end

  defp bag_within?(bag_rules, bag_of_bags) do
    bag_rules |> Map.keys() |> Enum.any?(fn bag -> Map.has_key?(bag_of_bags, bag) end)
  end

  def parse_line(line) do
    [key, val] = line |> String.trim() |> String.split(" contain ")
    {strip_bag(key), parse_val(val)}
  end

  def strip_bag(bag) do
    String.replace(bag, ~r/ bag[s]?/, "")
  end

  def parse_val(value) do
    value
    |> String.split(", ")
    |> Enum.into(%{}, &parse_bag/1)
  end

  def parse_bag("no other bags."), do: {:none, 0}

  def parse_bag(bag) do
    count =
      bag
      |> String.first()
      |> String.to_integer(10)

    description =
      String.slice(bag, 2..-1)
      |> String.replace(".", "")
      |> strip_bag()

    {description, count}
  end
end
