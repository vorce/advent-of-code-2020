defmodule Aoc2020.Day7 do
  @moduledoc """
  7
  """

  def parse!(input) do
    Enum.into(input, %{}, &parse_line/1)
  end

  def carry_in([], _bag_rules, acc), do: Enum.uniq(acc)

  def carry_in(bags, bag_rules, acc) do
    valid_bags =
      bag_rules
      |> Enum.filter(fn {_k, value} -> bag_within?(value, bags) end)
      |> Enum.map(fn {k, _v} -> k end)

    carry_in(valid_bags, bag_rules, valid_bags ++ acc)
  end

  defp bag_within?(%{none: 0}, _), do: false

  defp bag_within?(bag_rules, candidates) do
    bag_rules
    |> Enum.reject(fn {_k, v} -> v == 0 end)
    |> Enum.any?(fn {bag, _} -> bag in candidates end)
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
