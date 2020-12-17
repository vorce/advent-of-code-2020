defmodule Aoc2020.Day17 do
  def parse(lines, z \\ 0) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, y}, row_acc ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.reduce(row_acc, fn {c, x}, col_acc ->
        neighbors({x, y, z})
        |> Enum.reduce(col_acc, fn n, acc ->
          if Map.has_key?(acc, n), do: acc, else: Map.put(acc, n, ".")
        end)
        |> Map.put({x, y, z}, c)
      end)
    end)
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
    # world_with_edges =
    #   Enum.reduce(world, %{}, fn pos, acc ->
    #     nil
    #   end)

    Enum.reduce(world, %{}, fn {pos, val}, acc ->
      n = next(world, pos, val)
      Map.put(acc, pos, n)
    end)
  end

  def include_edges(world) do
    default = %{min_x: 999, max_x: -999, min_y: 999, max_y: -999, min_z: 999, max_z: -999}

    min_max =
      Enum.reduce(world, default, fn {{x, y, z}, _}, acc ->
        min_x = min(acc.min_x, x)
        max_x = max(acc.max_x, x)
        min_y = min(acc.min_y, y)
        max_y = max(acc.max_y, y)
        min_z = min(acc.min_z, z)
        max_z = max(acc.max_z, z)

        Map.put(acc, :min_x, min_x)
        |> Map.put(:max_x, max_x)
        |> Map.put(:min_y, min_y)
        |> Map.put(:max_y, max_y)
        |> Map.put(:min_z, min_z)
        |> Map.put(:max_z, max_z)
      end)

    Enum.reduce(world, %{}, fn {{x, y, z}, val} ->
      nil
      # if x == min_x do
      #   ns = neighbors({x, y, z})
      # end
    end)
  end
end
