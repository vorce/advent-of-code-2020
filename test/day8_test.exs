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
      assert Day8.execute_instruction(%{op: :nop, arg: 0}, 10, 0) == {11, 0}
      assert Day8.execute_instruction(%{op: :acc, arg: 11}, 8, 0) == {9, 11}
      assert Day8.execute_instruction(%{op: :acc, arg: 3}, 0, 1) == {1, 4}
      assert Day8.execute_instruction(%{op: :acc, arg: -2}, 0, 0) == {1, -2}
    end

    test "execute/4 on example" do
      instructions = Day8.parse!(@part1_example)

      {_, acc} = Day8.execute(instructions, 0, 0, MapSet.new())

      assert acc == 5
    end

    test "execute/4 on input file" do
      instructions =
        "test/data/day8_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day8.parse!()

      {_, acc} = Day8.execute(instructions, 0, 0, MapSet.new())

      assert acc == 1654
    end
  end

  describe "part 2" do
    test "execute/4 on fixed example" do
      instructions =
        @part1_example
        |> Day8.parse!()
        |> Map.put(7, %{op: :nop, arg: -4, line: 7})

      {_, acc} = Day8.execute(instructions, 0, 0, MapSet.new())

      assert acc == 8
    end

    @tag timeout: :infinity
    test "fix_loop/4 on example" do
      instructions =
        @part1_example
        |> Day8.parse!()

      {pointer, acc} = Day8.fix_loop(instructions, 0, 0, :jmp)

      assert acc == 8
    end
  end
end
