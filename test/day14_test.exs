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
      assert Day14.parse!(@example) == [
               %{op: :mask, val: %{1 => 0, 6 => 1}},
               %{op: :mem, i: 8, val: 11},
               %{op: :mem, i: 7, val: 101},
               %{op: :mem, i: 8, val: 0}
             ]
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
        |> Enum.reject(fn line -> line == "" end)
        |> Day14.parse!()

      mem = Day14.execute(prog)

      assert Day14.sum_memory(mem) == 6_317_049_172_545
    end
  end

  describe "part 2" do
    test "tree" do
      map = %{1 => "X", 2 => 1, 3 => "X"}
      tree = Day14.tree()

      res =
        Enum.reduce(map, Day14.tree(), fn {k, v}, acc ->
          Day14.add(acc, v)
        end)

      # assert res == %{}
      assert Day14.paths(res, [])
             |> Enum.chunk_by(fn x -> x == nil end)
             |> Enum.reject(fn x -> length(x) != 3 end) == []
    end

    test "foo" do
      result = Day14.foo("X1101X")
      assert result == ["X10110", "X10111", "01011X", "11011X"]

      # without X: "1101"

      # assert Enum.flat_map(result, fn r -> Day14.foo(r) end) |> Enum.uniq() == [
      #          "011010",
      #          "011011",
      #          "111010",
      #          "111011"
      #        ]

      map = %{0 => "X", 1 => 1, 2 => "X"}

      {pos, results} = Day14.expand(map, 0, map)

      assert pos == 1
      assert results == [%{0 => 0, 1 => 1, 2 => "X"}, %{0 => 1, 1 => 1, 2 => "X"}]

      {pos, results} = Day14.expand(results, pos, map)
      # assert pos == 3
      assert results == []

      # ["011010", "011011", "111010", "111011"]

      # map = %{1 => "X", 2 => 1, 3 => "X"}

      # assert Day14.float_combs(map, []) == %{}
      # |> Enum.sort() ==
      #          Enum.sort([
      #            %{1 => 1, 2 => 1, 3 => 1},
      #            %{1 => 0, 2 => 1, 3 => 1},
      #            %{1 => 1, 2 => 1, 3 => 0},
      #            %{1 => 0, 2 => 1, 3 => 0}
      #          ])
    end

    test "parse mask" do
      mask = "mask = 001X11X1X010X1X1010XX10X100101011000"
      assert Day14.parse_instruction(String.codepoints(mask)) == %{}

      %{
        op: :mask,
        val: %{
          11 => 1,
          34 => 0,
          26 => 0,
          15 => "X",
          20 => 1,
          17 => 0,
          25 => 1,
          13 => 0,
          0 => 0,
          8 => 1,
          7 => 0,
          1 => 0,
          32 => "X",
          35 => 0,
          3 => 1,
          6 => 1,
          2 => 0,
          33 => 1,
          10 => 0,
          9 => 0,
          19 => 0,
          14 => 1,
          5 => 0,
          18 => 1,
          31 => 1,
          22 => 1,
          29 => "X",
          21 => "X",
          27 => "X",
          24 => 0,
          30 => 1,
          23 => "X",
          28 => 1,
          16 => "X",
          4 => 1,
          12 => "X"
        }
      }
    end

    test "run_instruction2/3" do
      mask = %{op: :mask, val: %{0 => "X", 1 => 1, 4 => 1, 5 => "X"}}
      instruction = %{op: :mem, i: 42, val: 100}

      {result, _mask} = Day14.run_instruction2(instruction, %{}, mask.val)

      assert result == %{
               26 => 100,
               27 => 100,
               58 => 100,
               59 => 100
             }

      mask = %{op: :mask, val: %{0 => "X", 1 => "X", 3 => "X"}}
      instruction = %{op: :mem, i: 26, val: 1}
      {result, _mask} = Day14.run_instruction2(instruction, %{}, mask.val)

      assert result == %{
               16 => 1,
               17 => 1,
               18 => 1,
               19 => 1,
               24 => 1,
               25 => 1,
               26 => 1,
               27 => 1
             }
    end

    test "execute2" do
      input = [
        "mask = 000000000000000000000000000000X1001X",
        "mem[42] = 100",
        "mask = 00000000000000000000000000000000X0XX",
        "mem[26] = 1"
      ]

      prog = Day14.parse!(input)
      mem = Day14.execute2(prog)
      assert Day14.sum_memory(mem) == 208
    end

    test "small portion of input file" do
      prog =
        [
          "mask = 001X11X1X010X1X1010XX10X100101011000",
          "mem[43398] = 563312",
          "mem[51673] = 263978",
          "mem[18028] = 544304215"
          # "mask = X0100001101XX11100010XX110XX11111000",
          # "mem[24151] = 2013",
          # "mem[15368] = 19793",
          # "mem[45005] = 478",
          # "mem[1842] = 190808161",
          # "mem[36033] = 987",
          # "mem[26874] = 102"
        ]
        |> Day14.parse!()

      mem = Day14.execute2(prog)

      assert Day14.sum_memory(mem) == 163_980_101_632
    end

    @tag timeout: :infinity
    test "execute2 on input file" do
      prog =
        "test/data/day14_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day14.parse!()

      mem = Day14.execute2(prog)

      # 3404936041419: That's not the right answer; your answer is too low.
      assert Day14.sum_memory(mem) == 3_434_009_980_379
    end
  end
end
