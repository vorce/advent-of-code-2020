defmodule Aoc2020.Day7Test do
  use ExUnit.Case

  alias Aoc2020.Day7

  #   @part1_example_rules %{
  #     "light red" => %{"bright white" => 1, "muted yellow" => 2},
  # dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  # bright white bags contain 1 shiny gold bag.
  # muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  # shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  # dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  # vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  # faded blue bags contain no other bags.
  # dotted black bags contain no other bags.
  #   }

  @part1_example [
    "light red bags contain 1 bright white bag, 2 muted yellow bags.",
    "dark orange bags contain 3 bright white bags, 4 muted yellow bags.",
    "bright white bags contain 1 shiny gold bag.",
    "muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.",
    "shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.",
    "dark olive bags contain 3 faded blue bags, 4 dotted black bags.",
    "vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.",
    "faded blue bags contain no other bags.",
    "dotted black bags contain no other bags."
  ]
  describe "part 1" do
    test "parse!/1 example" do
      assert Day7.parse!(@part1_example) == %{
               "bright white" => %{"shiny gold" => 1},
               "dark olive" => %{"dotted black" => 4, "faded blue" => 3},
               "dark orange" => %{"bright white" => 3, "muted yellow" => 4},
               "dotted black" => %{none: 0},
               "faded blue" => %{none: 0},
               "light red" => %{"bright white" => 1, "muted yellow" => 2},
               "muted yellow" => %{"faded blue" => 9, "shiny gold" => 2},
               "shiny gold" => %{"dark olive" => 1, "vibrant plum" => 2},
               "vibrant plum" => %{"dotted black" => 6, "faded blue" => 5}
             }
    end

    test "parse_line/1" do
      assert Day7.parse_line("light red bags contain 1 bright white bag, 2 muted yellow bags.") ==
               {"light red", %{"bright white" => 1, "muted yellow" => 2}}
    end

    test "carry_in/2" do
      bag_rules = Day7.parse!(@part1_example)
      result = Day7.carry_in(["shiny gold"], bag_rules, [])

      assert length(result) == 4

      assert result |> Enum.sort() == [
               "bright white",
               "dark orange",
               "light red",
               "muted yellow"
             ]
    end

    test "carry_in/2 on input file" do
      bag_rules =
        "test/data/day7_input.txt"
        |> File.stream!()
        |> Stream.map(&Day7.parse_line/1)
        |> Enum.into(%{})

      assert map_size(bag_rules) == 594

      result = Day7.carry_in(["shiny gold"], bag_rules, [])

      # 26: That's not the right answer.
      # 436: That's not the right answer; your answer is too high.
      assert length(result) == 254
    end
  end

  describe "part 2" do
  end
end
