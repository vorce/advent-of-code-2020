defmodule Aoc2020.Day12Test do
  use ExUnit.Case

  alias Aoc2020.Day12

  describe "part 1" do
    @example [
      "F10",
      "N3",
      "F7",
      "R90",
      "F11"
    ]

    test "parse!/1" do
      assert Day12.parse!(@example) == [
               {"F", 10},
               {"N", 3},
               {"F", 7},
               {"R", 90},
               {"F", 11}
             ]
    end

    test "manhattan_distance/1 on example" do
      instructions = Day12.parse!(@example)
      assert Day12.manhattan_distance(instructions) == 25
    end

    test "manhattan_distance/1 on input file" do
      instructions =
        "test/data/day12_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day12.parse!()

      # 827: That's not the right answer; your answer is too low.
      assert Day12.manhattan_distance(instructions) == 879
    end
  end

  describe "part 2" do
  end
end
