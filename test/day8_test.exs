defmodule Aoc2020.Day8Test do
  use ExUnit.Case

  alias Aoc2020.Day8

  @part1_example [
    "nop +0",
    "acc +1",
    "jmp +4",
    "acc +3",
    "jmp -3",
    "acc -99",
    "acc +1",
    "jmp -4",
    "acc +6"
  ]

  @initial_state %Day8{acc: 0, pointer: 0}

  describe "part 1" do
    test "parse!/1" do
      assert Day8.parse!(@part1_example) == %{
               0 => %{arg: 0, op: :nop, line: 0},
               1 => %{arg: 1, op: :acc, line: 1},
               2 => %{arg: 4, op: :jmp, line: 2},
               3 => %{arg: 3, op: :acc, line: 3},
               4 => %{arg: -3, op: :jmp, line: 4},
               5 => %{arg: -99, op: :acc, line: 5},
               6 => %{arg: 1, op: :acc, line: 6},
               7 => %{arg: -4, op: :jmp, line: 7},
               8 => %{arg: 6, op: :acc, line: 8}
             }
    end

    test "execute_instruction/3" do
      assert Day8.execute_instruction(%{op: :nop, arg: 0}, %Day8{pointer: 10, acc: 0}) == %Day8{
               pointer: 11,
               acc: 0
             }

      assert Day8.execute_instruction(%{op: :acc, arg: 11}, %Day8{pointer: 8, acc: 0}) == %Day8{
               pointer: 9,
               acc: 11
             }

      assert Day8.execute_instruction(%{op: :acc, arg: 3}, %Day8{pointer: 0, acc: 1}) == %Day8{
               pointer: 1,
               acc: 4
             }

      assert Day8.execute_instruction(%{op: :acc, arg: -2}, %Day8{pointer: 0, acc: 0}) == %Day8{
               pointer: 1,
               acc: -2
             }
    end

    test "execute/4 on example" do
      instructions = Day8.parse!(@part1_example)

      assert Day8.execute(instructions, @initial_state, MapSet.new()) == %Day8{acc: 5, pointer: 1}
    end

    test "execute/4 on input file" do
      instructions =
        "test/data/day8_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day8.parse!()

      assert Day8.execute(instructions, @initial_state, MapSet.new()) == %Day8{
               acc: 1654,
               pointer: 516
             }
    end
  end

  describe "part 2" do
    test "fix_loop/4 on example" do
      instructions =
        @part1_example
        |> Day8.parse!()

      assert Day8.fix_loop(instructions, @initial_state, :jmp) == %Day8{
               acc: 8,
               pointer: 9
             }
    end

    test "fix_loops/3 on example" do
      instructions =
        @part1_example
        |> Day8.parse!()

      assert Day8.fix_loops(instructions, @initial_state) == %Day8{acc: 8, pointer: 9}
    end

    test "fix_loops/3 on input file" do
      instructions =
        "test/data/day8_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day8.parse!()

      assert Day8.fix_loops(instructions, @initial_state) == %Day8{
               acc: 833,
               pointer: 626
             }
    end
  end
end
