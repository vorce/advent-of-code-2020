defmodule Aoc2020.Day16Test do
  use ExUnit.Case

  alias Aoc2020.Day16

  describe "part 1" do
    test "invalid/2 on example input" do
      rules = [[1..3, 5..7], [6..11, 33..44], [13..40, 45..50]]

      assert Day16.invalid(rules, [7, 3, 47]) == []
      assert Day16.invalid(rules, [40, 4, 50]) == [4]
      assert Day16.invalid(rules, [55, 2, 20]) == [55]
      assert Day16.invalid(rules, [38, 6, 12]) == [12]
    end

    test "sum_invalid/2 on example input" do
      rules = [[1..3, 5..7], [6..11, 33..44], [13..40, 45..50]]

      nearby_tickets = [
        [7, 3, 47],
        [40, 4, 50],
        [55, 2, 20],
        [38, 6, 12]
      ]

      assert Day16.sum_invalid(rules, nearby_tickets) == 4 + 55 + 12
    end

    test "sum_invalid/2 on input file" do
      lines =
        "test/data/day16_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)

      rule_lines = Enum.take(lines, 20)
      rules = Day16.parse_rules(rule_lines)

      nearby_lines = Enum.drop(lines, 23)
      nearby_tickets = Day16.parse_nearby(nearby_lines)

      assert Day16.sum_invalid(rules, nearby_tickets) == 25984
    end
  end

  describe "part 2" do
  end
end
