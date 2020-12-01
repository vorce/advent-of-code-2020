defmodule Aoc2020.Day1 do
  @moduledoc """
  Day 1
  """

  @doc """
  Part 1
  """
  def sum_components(numbers, sum) do
    numbers
    |> Enum.reject(fn n -> n > sum end)
    |> check(sum)
    |> List.first()
  end

  def check(nrs, target) do
    Enum.flat_map(nrs, fn n ->
      others = Enum.reject(nrs, fn r -> r == n end)
      check_nr(n, others, target)
    end)
  end

  def check_nr(c, others, target) do
    others
    |> Enum.map(fn o -> result(c, o, target) end)
    |> Enum.reject(fn v -> v == :error end)
  end

  def result(a, b, target) when a + b == target, do: [a, b]
  def result(_a, _b, _target), do: :error

  @doc """
  Part 2
  """
  def sum_components2(numbers, target) do
    checker(numbers, target, &check_triplet/3)
  end

  def checker(numbers, target, check_fn) do
    Task.async_stream(numbers, fn candidate ->
      nrs_without_cand = Enum.reject(numbers, fn nr -> nr == candidate end)
      check_fn.(candidate, nrs_without_cand, target)
    end)
    |> Enum.reduce([], fn {:ok, c}, acc -> if c == [], do: acc, else: [c | acc] end)
  end

  def check_triplet(candidate1, numbers, target) do
    checker(numbers, candidate1, fn c, n, _t -> check_triplet(candidate1, c, n, target) end)
  end

  def check_triplet(c1, c2, numbers, target) do
    found = Enum.find(numbers, fn n -> c1 + c2 + n == target end)

    if is_nil(found) do
      []
    else
      [c1, c2, found]
    end
  end
end
