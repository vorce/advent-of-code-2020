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

  def adjacent_pos({x, y}) do
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
  end

  def no_occupied_adjacent?(map, p) do
    p
    |> adjacent_pos()
    |> Enum.all?(fn pos -> not occupied?(map, pos) end)
  end

  def occupied?(map, {x, y}) do
    Map.get(map, {x, y}) == "#"
  end

  def crowded?(map, p) do
    occupied_adjacent =
      p
      |> adjacent_pos()
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

  def adjacent_dirs() do
    [
      {-1, 0},
      {1, 0},
      {0, -1},
      {0, 1},
      {-1, -1},
      {1, -1},
      {1, 1},
      {-1, 1}
    ]
  end

  def find_adjacent_seen(map, {x, y}, acc) do
    adjacent_dirs()
    |> Enum.map(fn {dir_x, dir_y} ->
      {new_x, new_y} = {x + dir_x, y + dir_y}
      IO.inspect([pos: {x, y}, new: {new_x, new_y}, acc: acc], label: "ok")

      case Map.get(map, {new_x, new_y}) do
        nil ->
          acc

        "#" ->
          IO.inspect(label: "found an occupied seat at #{inspect({new_x, new_y})}")
          ["#" | acc]

        "L" ->
          ["L" | acc]

        "." ->
          find_adjacent_seen(map, {new_x + dir_x, new_x + dir_y}, acc)
      end
    end)
  end
end
