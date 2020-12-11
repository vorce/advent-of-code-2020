defmodule Aoc2020.Day11 do
  @moduledoc false

  def parse!(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
    |> Enum.into(%{})
  end

  def parse_line({line, line_nr}) do
    line
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.map(fn {pos, col_nr} -> {{col_nr, line_nr}, pos} end)
  end

  def iterate(map) do
    Enum.reduce(map, %{}, fn {pos, _val}, acc ->
      new_val = apply_rules(map, pos)
      Map.put(acc, pos, new_val)
    end)
  end

  def apply_rules(map, pos) do
    case Map.get(map, pos) do
      "L" ->
        if no_occupied_adjacent?(map, pos), do: "#", else: "L"

      "#" ->
        if crowded?(map, pos), do: "L", else: "#"

      "." ->
        "."
    end
  end

  def no_occupied_adjacent?(map, {x, y}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1},
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x + 1, y + 1},
      {x - 1, y + 1}
    ]
    |> Enum.all?(fn pos -> not occupied?(map, pos) end)
  end

  def occupied?(map, {x, y}) do
    Map.get(map, {x, y}) == "#"
  end

  def crowded?(map, {x, y}) do
    occupied_adjacent =
      [
        {x - 1, y},
        {x + 1, y},
        {x, y - 1},
        {x, y + 1},
        {x - 1, y - 1},
        {x + 1, y - 1},
        {x + 1, y + 1},
        {x - 1, y + 1}
      ]
      |> Enum.map(fn pos -> if occupied?(map, pos), do: 1, else: 0 end)

    Enum.sum(occupied_adjacent) >= 4
  end

  def output(map, height, width) do
    Enum.map(0..(height - 1), fn y -> output_row(map, y, width) end)
  end

  def output_row(map, y, width) do
    Enum.map(0..(width - 1), fn x -> Map.get(map, {x, y}) end)
    |> Enum.join()
  end

  def iterate_until_done(map, previous) when map == previous, do: map

  def iterate_until_done(map, _previous) do
    iterate_until_done(iterate(map), map)
  end

  def count_occupied_seats(map) do
    map
    |> Enum.map(fn {_pos, seat} -> if seat == "#", do: 1, else: 0 end)
    |> Enum.sum()
  end
end
