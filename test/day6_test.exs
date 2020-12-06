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
    test "combined_answers/1" do
      assert Day6.combined_answers(["abc"]) |> MapSet.size() == 3
      assert Day6.combined_answers(["a", "a", "a"]) |> MapSet.size() == 1
      assert Day6.combined_answers(["ab", "ac"]) |> MapSet.size() == 3
    end

    test "sum_answers/2 example" do
      assert Day6.sum_answers(@part1_example_input, &Day6.combined_answers/1) == 11
    end

    test "sum_answers/2 on input file" do
      input =
        "test/data/day6_input.txt"
        |> File.read!()
        |> String.split("\n")

      assert Day6.sum_answers(input, &Day6.combined_answers/1) == 6735
    end
  end

  describe "part 2" do
    test "common_answers/1" do
      assert Day6.common_answers(["abc"]) |> MapSet.size() == 3
      assert Day6.common_answers(["a", "b", "c"]) |> MapSet.size() == 0
      assert Day6.common_answers(["ab", "ac"]) |> MapSet.size() == 1
    end

    test "sum_answers/2 example" do
      assert Day6.sum_answers(@part1_example_input, &Day6.common_answers/1) == 6
    end

    test "sum_answers/2 on input file" do
      input =
        "test/data/day6_input.txt"
        |> File.read!()
        |> String.split("\n")

      assert Day6.sum_answers(input, &Day6.common_answers/1) == 3221
    end
  end
end
