defmodule Aoc2020.Day9 do
  @moduledoc """
  9
  """

  @spec parse!(path :: String.t()) :: [integer]
  def parse!(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(fn l -> l == "" end)
    |> Enum.map(&String.to_integer/1)
  end

  @spec first_invalid(input :: [integer], preamble_length :: integer) :: integer | nil
  def first_invalid([], _), do: nil

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

  @spec valid_xmas?(number :: nil | nil, preamble :: [integer]) :: boolean()
  def valid_xmas?(nil, _), do: true

  def valid_xmas?(number, preamble) do
    max = Enum.max(preamble)

    if number >= max * 2 do
      false
    else
      check_all_pairs(number, preamble) != nil
    end
  end

  def check_all_pairs(number, preamble) do
    pairs = for x <- preamble, y <- preamble, x != y, do: {x, y}
    Enum.find(pairs, fn {x, y} -> x + y == number end)
  end

  @min_range_len 2

  @spec find_contiguous(input :: [integer], target :: integer, range :: [integer]) :: [integer]
  def find_contiguous([], _target, _range), do: []

  def find_contiguous(input, target, range) do
    sum = Enum.sum(range)

    cond do
      sum == target ->
        range

      sum > target ->
        new_input = Enum.drop(input, 1)
        new_range = Enum.take(new_input, @min_range_len)
        find_contiguous(new_input, target, new_range)

      sum < target ->
        # Hm, why is this faster than `new_range = Enum.take(input, length(range) + 1)`?
        new_range =
          input
          |> Enum.drop(length(range))
          |> Enum.take(1)
          |> Enum.concat(range)

        find_contiguous(input, target, new_range)
    end
  end

  def encryption_weakness(input) do
    min = Enum.min(input)
    max = Enum.max(input)
    min + max
  end
end
