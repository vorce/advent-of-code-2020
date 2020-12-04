defmodule Aoc2020.Day4 do
  @moduledoc """
  Day 4!
  """

  defstruct [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid]

  def parse!(input) do
    input
    |> Enum.chunk_by(fn line -> line == "" end)
    |> Enum.reject(fn entry -> entry == [""] end)
    |> Enum.map(&parse_passport/1)
  end

  def parse_passport(parts) do
    parts
    |> Enum.map(&parse_part/1)
    |> Enum.reduce(%{}, fn item, acc ->
      Map.merge(acc, item)
    end)
    |> __MODULE__.__struct__()
  end

  def parse_part(part) do
    part
    |> String.split(" ")
    |> Enum.into(%{}, fn kv ->
      [key, val] = String.split(kv, ":")
      {String.to_atom(key), val}
    end)
  end

  def valid_passport?(%__MODULE__{} = passport) do
    cond do
      is_nil(passport.byr) -> false
      is_nil(passport.iyr) -> false
      is_nil(passport.eyr) -> false
      is_nil(passport.hgt) -> false
      is_nil(passport.hcl) -> false
      is_nil(passport.ecl) -> false
      is_nil(passport.pid) -> false
      true -> true
    end
  end
end
