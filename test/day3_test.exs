defmodule Aoc2020.Day3Test do
  use ExUnit.Case

  alias Aoc2020.Day3

  @part1_example_input [
    "..##.......",
    "#...#...#..",
    ".#....#..#.",
    "..#.#...#.#",
    ".#...##..#.",
    "..#.##.....",
    ".#.#.#....#",
    ".#........#",
    "#.##...#...",
    "#...##....#",
    ".#..#...#.#"
  ]

  describe "part 1" do
    test "parse example row" do
      row = "..##......."

      assert Day3.parse_row({row, 0}) == [
               {{0, 0}, "."},
               {{1, 0}, "."},
               {{2, 0}, "#"},
               {{3, 0}, "#"},
               {{4, 0}, "."},
               {{5, 0}, "."},
               {{6, 0}, "."},
               {{7, 0}, "."},
               {{8, 0}, "."},
               {{9, 0}, "."},
               {{10, 0}, "."}
             ]
    end

    test "parse example map" do
      map = Day3.parse_map(@part1_example_input)

      assert map.height == length(@part1_example_input)

      assert map.map == %{
               {0, 0} => ".",
               {0, 1} => "#",
               {0, 2} => ".",
               {0, 3} => ".",
               {0, 4} => ".",
               {0, 5} => ".",
               {0, 6} => ".",
               {0, 7} => ".",
               {0, 8} => "#",
               {0, 9} => "#",
               {0, 10} => ".",
               {1, 0} => ".",
               {1, 1} => ".",
               {1, 2} => "#",
               {1, 3} => ".",
               {1, 4} => "#",
               {1, 5} => ".",
               {1, 6} => "#",
               {1, 7} => "#",
               {1, 8} => ".",
               {1, 9} => ".",
               {1, 10} => "#",
               {2, 0} => "#",
               {2, 1} => ".",
               {2, 2} => ".",
               {2, 3} => "#",
               {2, 4} => ".",
               {2, 5} => "#",
               {2, 6} => ".",
               {2, 7} => ".",
               {2, 8} => "#",
               {2, 9} => ".",
               {2, 10} => ".",
               {3, 0} => "#",
               {3, 1} => ".",
               {3, 2} => ".",
               {3, 3} => ".",
               {3, 4} => ".",
               {3, 5} => ".",
               {3, 6} => "#",
               {3, 7} => ".",
               {3, 8} => "#",
               {3, 9} => ".",
               {3, 10} => ".",
               {4, 0} => ".",
               {4, 1} => "#",
               {4, 2} => ".",
               {4, 3} => "#",
               {4, 4} => ".",
               {4, 5} => "#",
               {4, 6} => ".",
               {4, 7} => ".",
               {4, 8} => ".",
               {4, 9} => "#",
               {4, 10} => "#",
               {5, 0} => ".",
               {5, 1} => ".",
               {5, 2} => ".",
               {5, 3} => ".",
               {5, 4} => "#",
               {5, 5} => "#",
               {5, 6} => "#",
               {5, 7} => ".",
               {5, 8} => ".",
               {5, 9} => "#",
               {5, 10} => ".",
               {6, 0} => ".",
               {6, 1} => ".",
               {6, 2} => "#",
               {6, 3} => ".",
               {6, 4} => "#",
               {6, 5} => ".",
               {6, 6} => ".",
               {6, 7} => ".",
               {6, 8} => ".",
               {6, 9} => ".",
               {6, 10} => ".",
               {7, 0} => ".",
               {7, 1} => ".",
               {7, 2} => ".",
               {7, 3} => ".",
               {7, 4} => ".",
               {7, 5} => ".",
               {7, 6} => ".",
               {7, 7} => ".",
               {7, 8} => "#",
               {7, 9} => ".",
               {7, 10} => ".",
               {8, 0} => ".",
               {8, 1} => "#",
               {8, 2} => ".",
               {8, 3} => "#",
               {8, 4} => ".",
               {8, 5} => ".",
               {8, 6} => ".",
               {8, 7} => ".",
               {8, 8} => ".",
               {8, 9} => ".",
               {8, 10} => "#",
               {9, 0} => ".",
               {9, 1} => ".",
               {9, 2} => "#",
               {9, 3} => ".",
               {9, 4} => "#",
               {9, 5} => ".",
               {9, 6} => ".",
               {9, 7} => ".",
               {9, 8} => ".",
               {9, 9} => ".",
               {9, 10} => ".",
               {10, 0} => ".",
               {10, 1} => ".",
               {10, 2} => ".",
               {10, 3} => "#",
               {10, 4} => ".",
               {10, 5} => ".",
               {10, 6} => "#",
               {10, 7} => "#",
               {10, 8} => ".",
               {10, 9} => "#",
               {10, 10} => "#"
             }
    end

    test "get_terrain/3" do
      map = Day3.parse_map(@part1_example_input)

      assert Day3.get_terrain(map, 0, 0) == "O"
      assert Day3.get_terrain(map, 2, 0) == "X"
      assert Day3.get_terrain(map, 10, 0) == "O"
      assert Day3.get_terrain(map, 11, 0) == "O"
      assert Day3.get_terrain(map, 13, 0) == "X"
      assert Day3.get_terrain(map, 0, 4) == "O"
      assert Day3.get_terrain(map, 1, 4) == "X"
      assert Day3.get_terrain(map, 11, 4) == "O"
      assert Day3.get_terrain(map, 12, 4) == "X"
    end

    test "plot_slope/2 for slope 3, 1 on example" do
      slope = {3, 1}
      map = Day3.parse_map(@part1_example_input)

      result = Day3.plot_slope(map, {0, 0}, slope, [])

      assert length(result) == map.height - 1

      assert result == [
               "O",
               "X",
               "O",
               "X",
               "X",
               "O",
               "X",
               "X",
               "X",
               "X"
             ]
    end

    test "plot_slope/2 for slope 3, 1 on input file" do
      slope = {3, 1}

      map =
        File.read!("test/data/day3_input.txt")
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day3.parse_map()

      result = Day3.plot_slope(map, {0, 0}, slope, [])
      assert length(result) == map.height - 1
      # 450: That's not the right answer; your answer is too high
      assert Enum.count(result, fn terrain -> terrain == "X" end) == 225
    end
  end

  describe "part 2" do
  end
end
