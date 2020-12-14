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
      assert Day14.parse!(@example, :part1) == [
               %{op: :mask, val: %{1 => 0, 6 => 1}},
               %{op: :mem, i: 8, val: 11},
               %{op: :mem, i: 7, val: 101},
               %{op: :mem, i: 8, val: 0}
             ]
    end

    test "execute/1" do
      prog = Day14.parse!(@example, :part1)

      assert Day14.execute(prog, :part1) == %{
               7 => 101,
               8 => 64
             }
    end

    test "sum_memory/1" do
      prog = Day14.parse!(@example, :part1)

      mem = Day14.execute(prog, :part1)

      assert Day14.sum_memory(mem) == 165
    end

    test "sum_memory/1 on input file" do
      prog =
        "test/data/day14_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day14.parse!(:part1)

      mem = Day14.execute(prog, :part1)

      assert Day14.sum_memory(mem) == 6_317_049_172_545
    end
  end

  describe "part 2" do
    test "parse mask" do
      mask = "mask = 001X11X1X010X1X1010XX10X100101011000"

      assert Day14.parse_instruction2(String.codepoints(mask)) == %{
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

    test "execute example" do
      input = [
        "mask = 000000000000000000000000000000X1001X",
        "mem[42] = 100",
        "mask = 00000000000000000000000000000000X0XX",
        "mem[26] = 1"
      ]

      prog = Day14.parse!(input, :part2)
      mem = Day14.execute(prog, :part2)
      assert Day14.sum_memory(mem) == 208
    end

    @tag timeout: :infinity
    test "execute2 on input file" do
      prog =
        "test/data/day14_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Enum.reject(fn line -> line == "" end)
        |> Day14.parse!(:part2)

      mem = Day14.execute(prog, :part2)

      # 3404936041419: That's not the right answer; your answer is too low.
      assert Day14.sum_memory(mem) == 3_434_009_980_379
    end

    @tag timeout: :infinity
    test "execute2 on part of input file" do
      prog =
        [
          "mask = 001X11X1X010X1X1010XX10X100101011000",
          "mem[43398] = 563312",
          "mem[51673] = 263978",
          "mem[18028] = 544304215",
          "mask = X0100001101XX11100010XX110XX11111000",
          "mem[24151] = 2013",
          "mem[15368] = 19793",
          "mem[45005] = 478",
          "mem[1842] = 190808161",
          "mem[36033] = 987",
          "mem[26874] = 102",
          "mask = 00X0000110110X000110010101XX0X010001",
          "mem[9507] = 7",
          "mem[50019] = 16475608",
          "mem[4334] = 129799",
          "mem[37373] = 182640",
          "mem[28170] = 534617265",
          "mem[6432] = 354252",
          "mem[36752] = 834628",
          "mask = 10100000101101100110X001X0X001100X10",
          "mem[36664] = 30481",
          "mem[6532] = 103013119",
          "mem[45659] = 15629",
          "mem[19533] = 167227",
          "mem[40461] = 344193233",
          "mem[6217] = 26713310",
          "mask = X0XX010100110101X0001101X11100X100X0",
          "mem[38530] = 6202",
          "mem[53032] = 13775",
          "mem[39333] = 1003152",
          "mem[3932] = 1240562",
          "mem[59246] = 12638"
        ]
        |> Day14.parse!(:part2)

      mem = Day14.execute(prog, :part2)

      assert Day14.sum_memory(mem) == 3_434_009_980_379
    end
  end
end
