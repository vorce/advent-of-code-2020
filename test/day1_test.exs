defmodule Aoc2020.Day1Test do
  use ExUnit.Case

  alias Aoc2020.Day1

  describe "part1" do
    test "sum_components returns the two components that add up to 2020" do
      numbers = [1721, 979, 366, 299, 675, 1456]
      assert Day1.sum_components(numbers, 2020) == [1721, 299]
    end

    test "sum_components on big input" do
      numbers =
        File.read!("test/data/day1_input.txt")
        |> String.split("\n")
        |> Enum.reject(fn l -> String.trim(l) == "" end)
        |> Enum.map(&String.to_integer/1)

      assert Day1.sum_components(numbers, 2020) == [455, 1565]
    end
  end

  describe "part2" do
    test "triple sum to target" do
      numbers = [1721, 979, 366, 299, 675, 1456]

      result =
        Day1.sum_components2(numbers, 2020)
        |> List.first()
        |> List.first()
        |> Enum.sort()

      assert result == [366, 675, 979]
    end

    @tag timeout: :infinity
    test "triple sum to target big input" do
      numbers =
        File.read!("test/data/day1_input.txt")
        |> String.split("\n")
        |> Enum.reject(fn l -> String.trim(l) == "" end)
        |> Enum.map(&String.to_integer/1)

      result =
        Day1.sum_components2(numbers, 2020)
        |> List.first()
        |> List.first()
        |> Enum.sort()

      assert result == [183, 695, 1142]
    end
  end
end
