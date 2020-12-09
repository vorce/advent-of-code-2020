defmodule Aoc2020.Day9Test do
  use ExUnit.Case

  alias Aoc2020.Day9

  @part1_input_example [
    35,
    20,
    15,
    25,
    47,
    40,
    62,
    55,
    65,
    95,
    102,
    117,
    150,
    182,
    127,
    219,
    299,
    277,
    309,
    576
  ]

  describe "part 1" do
    test "first_invalid/2 on example" do
      assert Day9.first_invalid(@part1_input_example, 5) == 127
    end

    test "first_invalid/2 on input file" do
      input = Day9.parse!("test/data/day9_input.txt")

      assert Day9.first_invalid(input, 25) == 542_529_149
    end
  end

  @min_range_len 2

  describe "part 2" do
    test "find_contiguous/3 on example" do
      first_range = Enum.take(@part1_input_example, @min_range_len)

      assert Day9.find_contiguous(@part1_input_example, 127, first_range) |> Enum.sort() == [
               15,
               25,
               40,
               47
             ]
    end

    test "encryption_weakness/1" do
      assert Day9.encryption_weakness([15, 25, 47, 40]) == 15 + 47
    end

    test "find_contiguous/3 on input file" do
      input = Day9.parse!("test/data/day9_input.txt")
      first_range = Enum.take(input, @min_range_len)

      result = Day9.find_contiguous(input, 542_529_149, first_range)

      assert Day9.encryption_weakness(result) == 75_678_618
    end
  end
end
