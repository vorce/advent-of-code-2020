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

  def iterate(map, crowded_threshold \\ 4) do
    Enum.reduce(map, %{}, fn {pos, _val}, acc ->
      new_val = apply_rules(map, pos, crowded_threshold)
      Map.put(acc, pos, new_val)
    end)
  end

  def iterate2(map) do
    # IO.puts("iterate2")
    # IO.inspect(map, label: "map")

    Enum.reduce(map, %{}, fn {pos, _val}, acc ->
      new_val = apply_rules2(map, pos)
      Map.put(acc, pos, new_val)
    end)
  end

  def apply_rules2(map, pos) do
    case Map.get(map, pos) do
      "L" ->
        # empty seats that see no occupied seats become occupied,
        if no_occupied_adjacent2?(map, pos) do
          # IO.inspect(map, label: "Changing L to #. No occupied seats seen from #{inspect(pos)}")
          "#"
        else
          "L"
        end

      "#" ->
        if crowded2?(map, pos, 5) do
          # IO.inspect(map, label: "Changing # to L. It is crowded at #{inspect(pos)}")
          "L"
        else
          "#"
        end

      "." ->
        "."
    end
  end

  def apply_rules(map, pos, crowded_threshold) do
    case Map.get(map, pos) do
      "L" ->
        if no_occupied_adjacent?(map, pos), do: "#", else: "L"

      "#" ->
        if crowded?(map, pos, crowded_threshold), do: "L", else: "#"

      "." ->
        "."
    end
  end

  def no_occupied_adjacent2?(map, pos) do
    map
    |> adjacent_seen(pos)
    # |> IO.inspect(label: "adjacent_seend")
    |> Enum.all?(fn seat -> seat == "L" end)
  end

  def adjacent_seen(map, pos) do
    Enum.flat_map(adjacent_dirs(), fn {dir_x, dir_y} ->
      find_adjacent_seen(map, pos, {dir_x, dir_y}, [])
    end)
  end

  defp debug(seen, map, pos) do
    # if pos == {2, 0} do
    # IO.inspect([seen: seen, map: map], label: "adjacent seen from #{inspect(pos)}")
    # end

    seen
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

  def crowded?(map, p, crowded_threshold) do
    occupied_adjacent =
      p
      |> adjacent_pos()
      |> Enum.map(fn pos -> if occupied?(map, pos), do: 1, else: 0 end)

    Enum.sum(occupied_adjacent) >= crowded_threshold
  end

  def crowded2?(map, p, crowded_threshold) do
    seen =
      adjacent_seen(map, p)
      |> Enum.map(fn seat ->
        case seat do
          "#" -> 1
          _ -> 0
        end
      end)

    Enum.sum(seen) >= crowded_threshold
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

  def iterate_until_done2(map, previous) when map == previous, do: map

  def iterate_until_done2(map, _previous) do
    iterate_until_done2(iterate2(map), map)
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

  def find_adjacent_seen(map, {x, y}, {dir_x, dir_y}, acc) do
    {new_x, new_y} = {x + dir_x, y + dir_y}

    case Map.get(map, {new_x, new_y}) do
      nil ->
        acc

      "#" ->
        ["#" | acc]

      "L" ->
        ["L" | acc]

      "." ->
        find_adjacent_seen(map, {new_x, new_y}, {dir_x, dir_y}, acc)
    end
  end
end
