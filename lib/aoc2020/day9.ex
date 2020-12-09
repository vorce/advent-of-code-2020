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

  def find_contiguous([], _target, _pos), do: nil

  def find_contiguous(input, target, pos) do
    range = Enum.take(input, pos)

    cond do
      Enum.sum(range) == target and length(range) >= 2 ->
        range

      Enum.sum(range) > target ->
        find_contiguous(Enum.drop(input, 1), target, 1)

      true ->
        find_contiguous(input, target, pos + 1)
    end
  end

  def encryption_weakness(input) do
    min = Enum.min(input)
    max = Enum.max(input)
    min + max
  end
end
