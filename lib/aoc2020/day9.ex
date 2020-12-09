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

  @spec find_contiguous(input :: [integer], target :: integer, range_length :: integer) :: [
          integer
        ]
  def find_contiguous([], _target, _range_length), do: []

  def find_contiguous(input, target, range_length) do
    range = Enum.take(input, range_length)
    sum = Enum.sum(range)

    cond do
      sum == target ->
        range

      sum > target ->
        min_range_len = 2
        find_contiguous(Enum.drop(input, 1), target, min_range_len)

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
