defmodule Aoc2020.Day17Test do
  use ExUnit.Case

  alias Aoc2020.Day17

  describe "part 1" do
    test "parse" do
      inp = [
        ".#.",
        "..#",
        "###"
      ]

      assert Day17.parse(inp) == %{
               {0, 0, 0} => ".",
               {1, 0, 0} => "#",
               {2, 0, 0} => ".",
               {0, 1, 0} => ".",
               {1, 1, 0} => ".",
               {2, 1, 0} => "#",
               {0, 2, 0} => "#",
               {1, 2, 0} => "#",
               {2, 2, 0} => "#"
             }
    end

    test "ticks on input file" do
      input = [
        "##.#...#",
        "#..##...",
        "....#..#",
        "....####",
        "#.#....#",
        "###.#.#.",
        ".#.#.#..",
        ".#.....#",
      ] |> Day17.parse()

      world = Enum.reduce(1..6, input, fn _i, acc ->
        Day17.tick(acc)
      end)

      active_count = Enum.reduce(world, 0, fn {pos, val}, acc ->
        if val == "#" do
          1 + acc
        else
          acc
        end
      end)

      assert active_count == 315
    end
  end

  describe "part 2" do
  end
end
