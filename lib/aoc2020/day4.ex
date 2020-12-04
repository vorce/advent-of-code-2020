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

  def valid_passport2?(%__MODULE__{} = passport) do
    valid_passport_field?(:byr, passport.byr) and
      valid_passport_field?(:iyr, passport.iyr) and
      valid_passport_field?(:eyr, passport.eyr) and
      valid_passport_field?(:hgt, passport.hgt) and
      valid_passport_field?(:hcl, passport.hcl) and
      valid_passport_field?(:ecl, passport.ecl) and
      valid_passport_field?(:pid, passport.pid)
  end

  def valid_passport_field?(:cid, _), do: true
  def valid_passport_field?(_, nil), do: false

  def valid_passport_field?(:byr, val), do: year_within?(val, 1920, 2002)

  def valid_passport_field?(:iyr, val), do: year_within?(val, 2010, 2020)

  def valid_passport_field?(:eyr, val), do: year_within?(val, 2020, 2030)

  def valid_passport_field?(:hgt, val) do
    unit =
      String.codepoints(val) |> Enum.reverse() |> Enum.take(2) |> Enum.join() |> String.reverse()

    case unit do
      "cm" ->
        val
        |> height_without_unit()
        |> valid_cm?()

      "in" ->
        val
        |> height_without_unit()
        |> valid_in?()

      _ ->
        false
    end
  end

  def valid_passport_field?(:hcl, val) do
    cp = String.codepoints(val)
    valid_chars = ~r/^[a-f]|[0-9]/

    if length(cp) == 7 and hd(cp) == "#" do
      Enum.drop(cp, 1)
      |> Enum.map(fn c -> Regex.match?(valid_chars, c) end)
      |> Enum.all?(&(&1 == true))
    else
      false
    end
  end

  def valid_passport_field?(:ecl, val)
      when val in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
      do: true

  def valid_passport_field?(:ecl, _val), do: false

  def valid_passport_field?(:pid, val) do
    with 9 <- String.length(val),
         {_i, ""} <- Integer.parse(val) do
      true
    else
      _ -> false
    end
  end

  @spec year_within?(year_str :: binary, ge :: integer, le :: integer) :: boolean
  def year_within?(year_str, ge, le) do
    case Integer.parse(year_str) do
      {i, ""} when i >= ge and i <= le ->
        true

      _ ->
        false
    end
  end

  defp height_without_unit(height) do
    height
    |> String.codepoints()
    |> Enum.reverse()
    |> Enum.drop(2)
    |> Enum.reverse()
    |> Enum.join()
  end

  def valid_cm?(without_unit) do
    case Integer.parse(without_unit) do
      {i, ""} when i >= 150 and i <= 193 -> true
      _ -> false
    end
  end

  def valid_in?(without_unit) do
    case Integer.parse(without_unit) do
      {i, ""} when i >= 59 and i <= 76 -> true
      _ -> false
    end
  end
end
