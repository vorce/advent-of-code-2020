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
    test "ticket_column" do
      rule0 = [0..1, 4..19]
      rule1 = [0..5, 8..19]
      rule2 = [0..13, 16..19]

      nearby = [
        [3, 9, 18],
        [15, 1, 5],
        [5, 14, 9]
      ]

      assert Day16.ticket_column(rule0, nearby, []) == [1, 2]
      assert Day16.ticket_column(rule1, nearby, []) == [0, 1, 2]
      assert Day16.ticket_column(rule2, nearby, []) == [0]

      # [[1, 2], [0, 1, 2], [0]]
    end

    test "distribute_columns" do
      candidates = [{0, [1, 2]}, {1, [0, 1, 2]}, {2, [0]}]
      assert Day16.distribute_columns(candidates) == %{0 => 2, 1 => 0, 2 => 1}
      # keys=column, value=rule
      # [{2, 0}, {0, 1}, {1, 2}]
    end

    test "candidates on example" do
      rules = [[0..1, 4..19], [0..5, 8..19], [0..13, 16..19]]

      nearby = [
        [3, 9, 18],
        [15, 1, 5],
        [5, 14, 9]
      ]

      assert Day16.candidates(rules, nearby) == [{0, [1, 2]}, {1, [0, 1, 2]}, {2, [0]}]
    end

    test "map cols on input" do
      lines =
        "test/data/day16_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)

      rule_lines = Enum.take(lines, 20)

      rules = Day16.parse_rules(rule_lines)

      nearby_lines = Enum.drop(lines, 23)

      nearby_tickets = Day16.parse_nearby(nearby_lines)

      # keys=column, value=rule
      mapping =
        rules
        |> Day16.candidates(nearby_tickets)
        |> IO.inspect(label: "candidates")
        |> Day16.distribute_columns()
        |> IO.inspect(label: "distributed")

      # keys=rule, value=column
      reversed_mapping = Enum.into(mapping, %{}, fn {column, rule} -> {rule, column} end)

      cols =
        [
          Map.get(reversed_mapping, 0),
          Map.get(reversed_mapping, 1),
          Map.get(reversed_mapping, 2),
          Map.get(reversed_mapping, 3),
          Map.get(reversed_mapping, 4),
          Map.get(reversed_mapping, 5)
        ]
        |> IO.inspect(label: "columns for departure*")

      my_ticket =
        [
          113,
          197,
          59,
          167,
          151,
          107,
          79,
          73,
          109,
          157,
          199,
          193,
          83,
          53,
          89,
          71,
          149,
          61,
          67,
          163
        ]
        |> Enum.with_index()
        |> Enum.map(fn {elem, i} -> {i, elem} end)
        |> Enum.into(%{})

      # [20, 16, 22, 14, 19, 13]
      assert Enum.reduce(cols, 1, fn col, acc ->
               acc * Map.get(my_ticket, col)
             end) == 0
    end
  end
end
