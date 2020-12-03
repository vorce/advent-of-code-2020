defmodule Aoc2020.Day3 do
  @moduledoc """
  With the toboggan login problems resolved, you set off toward the airport. While travel by toboggan might be easy, it's certainly not safe: there's very minimal steering and the area is covered in trees. You'll need to see which angles will take you near the fewest trees.

  Due to the local geology, trees in this area only grow on exact integer coordinates in a grid. You make a map (your puzzle input) of the open squares (.) and trees (#) you can see. For example:

  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#

  These aren't the only trees, though; due to something you read about once involving arboreal genetics and biome stability, the same pattern repeats to the right many times:

  ..##.........##.........##.........##.........##.........##.......  --->
  #...#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
  .#....#..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
  ..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
  .#...##..#..#...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
  ..#.##.......#.##.......#.##.......#.##.......#.##.......#.##.....  --->
  .#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
  .#........#.#........#.#........#.#........#.#........#.#........#
  #.##...#...#.##...#...#.##...#...#.##...#...#.##...#...#.##...#...
  #...##....##...##....##...##....##...##....##...##....##...##....#
  .#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

  You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

  The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers); start by counting all the trees you would encounter for the slope right 3, down 1:

  From your starting position at the top-left, check the position that is right 3 and down 1. Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

  The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

  ..##.........##.........##.........##.........##.........##.......  --->
  #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
  .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
  ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
  .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
  ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
  .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
  .#........#.#........X.#........#.#........#.#........#.#........#
  #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
  #...##....##...##....##...#X....##...##....##...##....##...##....#
  .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->

  In this example, traversing the map using this slope would cause you to encounter 7 trees.

  Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
  """

  defstruct [:map, :height, :width]

  def parse_map(input) do
    map =
      input
      |> Enum.with_index()
      |> Enum.flat_map(&parse_row/1)
      |> Enum.into(%{})

    %__MODULE__{map: map, height: length(input), width: String.length(hd(input))}
  end

  def parse_row({row, y}) do
    row
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.map(fn {c, x} -> {{x, y}, c} end)
  end

  def plot_slope(%__MODULE__{height: height}, {_x, y}, _, acc) when y >= height - 1,
    do: Enum.reverse(acc)

  def plot_slope(map, {start_x, start_y}, {slope_x, slope_y}, acc) do
    x = start_x + slope_x
    y = start_y + slope_y
    terrain = get_terrain(map, x, y)

    [terrain | plot_slope(map, {x, y}, {slope_x, slope_y}, acc)]
  end

  def get_terrain(%__MODULE__{map: map, width: width}, x, y) do
    repeating_x = rem(x, width)
    val = Map.get(map, {repeating_x, y})

    case val do
      "." -> "O"
      "#" -> "X"
    end
  end
end
