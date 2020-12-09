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
      input =
        "test/data/day9_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn l -> l == "" end)
        |> Enum.map(&String.to_integer/1)

      assert Day9.first_invalid(input, 25) == 542_529_149
    end
  end

  describe "part 2" do
    test "find_contiguous/3 on example" do
      assert Day9.find_contiguous(@part1_input_example, 127, 2) == [15, 25, 47, 40]
    end

    test "encryption_weakness/1" do
      assert Day9.encryption_weakness([15, 25, 47, 40]) == 15 + 47
    end

    test "find_contiguous/3 on input file" do
      input =
        "test/data/day9_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn l -> l == "" end)
        |> Enum.map(&String.to_integer/1)

      result = Day9.find_contiguous(input, 542_529_149, 2)

      assert Day9.encryption_weakness(result) == 75_678_618
    end
  end
end
