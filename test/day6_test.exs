defmodule Aoc2020.Day6Test do
  use ExUnit.Case

  alias Aoc2020.Day6

  @part1_example_input [
    "abc",
    "",
    "a",
    "b",
    "c",
    "",
    "ab",
    "ac",
    "",
    "a",
    "a",
    "a",
    "a",
    "",
    "b"
  ]

  describe "part 1" do
    test "count_group/1" do
      assert Day6.count_group(["abc"]) |> MapSet.size() == 3
      assert Day6.count_group(["a", "a", "a"]) |> MapSet.size() == 1
      assert Day6.count_group(["ab", "ac"]) |> MapSet.size() == 3
    end

    test "sum_answers/1" do
      assert Day6.sum_answers(@part1_example_input) == 11
    end

    test "sum_answers/1 on input file" do
      input =
        "test/data/day6_input.txt"
        |> File.read!()
        |> String.split("\n")

      assert Day6.sum_answers(input) == 6735
    end
  end

  describe "part 2" do
    test "count_group2/1" do
      assert Day6.count_group2(["abc"]) |> MapSet.size() == 3
      assert Day6.count_group2(["a", "b", "c"]) |> MapSet.size() == 0
      assert Day6.count_group2(["ab", "ac"]) |> MapSet.size() == 1
    end

    test "sum_answers2/1" do
      assert Day6.sum_answers2(@part1_example_input) == 6
    end

    test "sum_answers2/1 on input file" do
      input =
        "test/data/day6_input.txt"
        |> File.read!()
        |> String.split("\n")

      assert Day6.sum_answers2(input) == 3221
    end
  end
end
