defmodule Aoc2020.Day17 do
  def parse(lines, z \\ 0) do
    lines
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {c, x} ->
        {{x, y, z}, c}
      end)
    end)
    |> Enum.into(%{})
  end

  # (x,y,z), there exists a single cube which is either active or inactive
  # For all [x, y, z] -> true | false
  # all except input is false.
  # 6 cycles.
  # neighbors: [x-1, y, z], [x-1, y-1, z], [x-1, y, z-1], ..., []
  def neighbors({x, y, z}) do
    [
      # 2d
      {x + 1, y, z},
      {x + 1, y + 1, z},
      {x, y + 1, z},
      {x - 1, y + 1, z},
      {x - 1, y, z},
      {x - 1, y - 1, z},
      {x, y - 1, z},
      {x + 1, y - 1, z},

      # 3d
      {x + 1, y, z - 1},
      {x + 1, y + 1, z - 1},
      {x, y + 1, z - 1},
      {x - 1, y + 1, z - 1},
      {x - 1, y, z - 1},
      {x - 1, y - 1, z - 1},
      {x, y - 1, z - 1},
      {x + 1, y - 1, z - 1},
      {x + 1, y, z + 1},
      {x + 1, y + 1, z + 1},
      {x, y + 1, z + 1},
      {x - 1, y + 1, z + 1},
      {x - 1, y, z + 1},
      {x - 1, y - 1, z + 1},
      {x, y - 1, z + 1},
      {x + 1, y - 1, z + 1},
      {x, y, z + 1},
      {x, y, z - 1}
    ]
  end

  def next(world, {x, y, z}, "#") do
    ns = neighbors({x, y, z})

    active_ns =
      ns
      |> Enum.map(&Map.get(world, &1, "."))
      |> Enum.count(fn active? -> active? == "#" end)

    case active_ns do
      2 -> "#"
      3 -> "#"
      _ -> "."
    end
  end

  def next(world, {x, y, z}, ".") do
    ns = neighbors({x, y, z})

    active_ns =
      ns
      |> Enum.map(&Map.get(world, &1, "."))
      |> Enum.count(fn active? -> active? == "#" end)

    case active_ns do
      3 -> "#"
      _ -> "."
    end
  end

  def tick(world) do
    keys = Map.keys(world)
    {{min_x, _, _}, {max_x, _, _}} = Enum.min_max_by(keys, fn {x, _y, _z} -> x end)
    {{_, min_y, _}, {_, max_y, _}} = Enum.min_max_by(keys, fn {_x, y, _z} -> y end)
    {{_, _, min_z}, {_, _, max_z}} = Enum.min_max_by(keys, fn {_x, _y, z} -> z end)

    Enum.reduce((min_z - 1)..(max_z + 1), %{}, fn z, z_acc ->
      Map.merge(z_acc, Enum.reduce((min_x - 1)..(max_x + 1), %{}, fn x, x_acc ->
        Map.merge(x_acc, Enum.reduce((min_y - 1)..(max_y + 1), %{}, fn y, z_acc ->
          pos = {x, y, z}
          val = Map.get(world, pos, ".")
          n = next(world, pos, val)
          Map.put(z_acc, pos, n)
        end))
      end))
    end)
  end
end
