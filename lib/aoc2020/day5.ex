defmodule Aoc2020.Day5 do
  @moduledoc """
  Day 5...
  """

  def code_to_position(code, row_range, col_range) do
    code = String.codepoints(code)

    row =
      code
      |> Enum.take(7)
      |> find_pos(row_range, %{lower: "F", upper: "B"})

    column =
      code
      |> Enum.reverse()
      |> Enum.take(3)
      |> Enum.reverse()
      |> find_pos(col_range, %{lower: "L", upper: "R"})

    {row, column}
  end

  def find_pos([], min.._max, _mapping), do: min

  def find_pos([i | rest], min..max, %{lower: l, upper: u} = mapping) do
    case i do
      ^l ->
        max = min + div(max - min, 2)
        find_pos(rest, min..max, mapping)

      ^u ->
        min = max + div(min - max, 2)
        find_pos(rest, min..max, mapping)
    end
  end

  def seat_id({row, column}), do: row * 8 + column

  def missing_seats(path, row_range, _cmin..cmax = col_range) do
    path
    |> File.stream!()
    |> Stream.reject(fn line -> line == "\n" or line == "" end)
    |> Stream.map(fn line ->
      code_to_position(String.trim(line), row_range, col_range)
    end)
    |> Enum.sort()
    |> Enum.chunk_by(fn {row, _col} -> row end)
    |> Enum.reject(fn row -> length(row) > cmax end)
  end
end
