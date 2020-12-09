defmodule Aoc2020.Day9 do
  @moduledoc """
  9
  """

  def first_invalid([], _, _), do: nil

  def first_invalid(input, preamble_length) do
    preamble = Enum.take(input, preamble_length)
    others = Enum.drop(input, preamble_length)
    number = List.first(others)

    case valid_xmas?(number, preamble) do
      true ->
        first_invalid(Enum.drop(input, 1), preamble_length)

      false ->
        number
    end
  end

  def valid_xmas?(nil, _), do: true

  def valid_xmas?(number, preamble) do
    max = Enum.max(preamble)

    if number >= max * 2 do
      false
    else
      found = check_all_pairs(number, preamble)
      found != nil
    end
  end

  def check_all_pairs(number, preamble) do
    pairs = for x <- preamble, y <- preamble, x != y, do: {x, y}
    Enum.find(pairs, fn {x, y} -> x + y == number end)
  end

  def find_contiguous([], _target, _range_length), do: nil

  def find_contiguous(input, target, range_length) do
    range = Enum.take(input, range_length)
    sum = Enum.sum(range)

    cond do
      sum == target ->
        range

      sum > target ->
        find_contiguous(Enum.drop(input, 1), target, 2)

      true ->
        find_contiguous(input, target, range_length + 1)
    end
  end

  def encryption_weakness(input) do
    min = Enum.min(input)
    max = Enum.max(input)
    min + max
  end
end
