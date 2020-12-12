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

    test "manhattan_distance/2 on example" do
      instructions = Day12.parse!(@example)
      assert Day12.manhattan_distance(instructions, :part1) == 25
    end

    test "manhattan_distance/2 on input file" do
      instructions =
        "test/data/day12_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day12.parse!()

      # 827: That's not the right answer; your answer is too low.
      assert Day12.manhattan_distance(instructions, :part1) == 879
    end
  end

  describe "part 2" do
    test "part2_instruction/2 R" do
      # 10 units east and 4 units north
      start = %Day12{waypoint: %{ew: 10, ns: 4}}
      state = Day12.part2_instruction(start, {"R", 90})
      # 4 units east and 10 units south of the ship
      assert state == %Day12{waypoint: %{ew: 4, ns: -10}}

      state = Day12.part2_instruction(state, {"R", 90})
      assert state == %Day12{waypoint: %{ew: -10, ns: -4}}

      state = Day12.part2_instruction(state, {"R", 90})
      assert state == %Day12{waypoint: %{ew: -4, ns: 10}}

      state = Day12.part2_instruction(state, {"R", 90})
      assert state == start
    end

    test "part2_instruction/2 L" do
      start = %Day12{waypoint: %{ew: 1, ns: 2}}
      instruction = {"L", 90}
      state = Day12.part2_instruction(start, instruction)
      assert state == %Day12{waypoint: %{ew: -2, ns: 1}}

      state = Day12.part2_instruction(state, instruction)
      assert state == %Day12{waypoint: %{ew: -1, ns: -2}}

      state = Day12.part2_instruction(state, instruction)
      assert state == %Day12{waypoint: %{ew: 2, ns: -1}}

      state = Day12.part2_instruction(state, instruction)
      assert state == start
    end

    test "manhattan_distance/2 on example" do
      instructions = Day12.parse!(@example)
      assert Day12.manhattan_distance(instructions, :part2) == 286
    end

    test "manhattan_distance/2 on input file" do
      instructions =
        "test/data/day12_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day12.parse!()

      # 14664: That's not the right answer; your answer is too low.
      assert Day12.manhattan_distance(instructions, :part2) == 18107
    end
  end
end
