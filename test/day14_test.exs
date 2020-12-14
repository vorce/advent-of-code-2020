defmodule Aoc2020.Day14Test do
  use ExUnit.Case

  alias Aoc2020.Day14

  @example [
    "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
    "mem[8] = 11",
    "mem[7] = 101",
    "mem[8] = 0"
  ]

  describe "part 1" do
    test "parse!/1" do
      assert Day14.parse!(@example) == %Day14{
               # "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X"
               mask: %{1 => 0, 6 => 1},
               instructions: [
                 %{op: :mem, i: 8, val: 11},
                 %{op: :mem, i: 7, val: 101},
                 %{op: :mem, i: 8, val: 0}
               ]
             }
    end

    test "execute/1" do
      prog = Day14.parse!(@example)

      assert Day14.execute(prog) == %{
               7 => 101,
               8 => 64
             }
    end

    test "sum_memory/1" do
      prog = Day14.parse!(@example)

      mem = Day14.execute(prog)

      assert Day14.sum_memory(mem) == 165
    end

    test "sum_memory/1 on input file" do
      prog =
        "test/data/day14_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Day14.parse!()

      mem = Day14.execute(prog)

      assert Day14.sum_memory(mem) == 165
    end
  end

  describe "part 2" do
  end
end
