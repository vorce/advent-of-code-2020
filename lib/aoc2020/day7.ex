defmodule Aoc2020.Day7 do
  @moduledoc """
  7
  """

  def parse!(input) do
    Enum.into(input, %{}, &parse_line/1)
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

  def bag_colors([], _bag_rules, acc), do: acc

  def bag_colors(bags, bag_rules, acc) do
    valid_bags =
      bag_rules
      |> Enum.filter(fn {_k, value} -> bag_within?(value, bags) end)
      |> Enum.map(fn {k, _v} -> k end)

    bag_colors(valid_bags, bag_rules, valid_bags |> MapSet.new() |> MapSet.union(acc))
  end

  defp bag_within?(%{none: 0}, _), do: false

  defp bag_within?(bag_rules, candidates) do
    Enum.any?(bag_rules, fn {bag, _} -> bag in candidates end)
  end

  # So, a single shiny gold bag must contain:
  # 1 dark olive bag (and the 7 bags within it)
  # plus 2 vibrant plum bags (and the 11 bags within each of those):
  #   1 + 1*7 + 2 + 2*11 = 32 bags!
  # ...
  # step1: shiny gold => %{"dark olive" => 1, "vibrant plum" => 2}
  # step2: 1 + (1 * bag_count("dark olive")) + ...
  def required_bag_count(bag, bag_rules) do
    sub_bags = Map.get(bag_rules, bag)

    case sub_bags do
      %{none: 0} ->
        0

      sub ->
        top_level = top_level_count(sub)

        bags_inside =
          sub
          |> Enum.map(fn {sub_bag, size} ->
            size * required_bag_count(sub_bag, bag_rules)
          end)
          |> Enum.sum()

        bags_inside + top_level
    end
  end

  defp top_level_count(bags) do
    bags |> Enum.map(fn {_k, v} -> v end) |> Enum.sum()
  end
end
