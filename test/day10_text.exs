defmodule Aoc2020.Day10Test do
  use ExUnit.Case

  alias Aoc2020.Day10

  @part1_example_input [
    16,
    10,
    15,
    5,
    1,
    11,
    7,
    19,
    6,
    12,
    4
  ]

  describe "part 1" do
    test "adapter_chain/2" do
      assert Day10.adapter_chain(@part1_example_input) == [
               0,
               1,
               4,
               5,
               6,
               7,
               10,
               11,
               12,
               15,
               16,
               19,
               22
             ]
    end

    test "differences/1 on example 1" do
      chain = Day10.adapter_chain(@part1_example_input)

      assert Day10.differences(chain) == %{
               1 => 7,
               3 => 5
             }
    end

    test "differences/1 on example 2" do
      example2 = [
        28,
        33,
        18,
        42,
        31,
        14,
        46,
        20,
        48,
        47,
        24,
        23,
        49,
        45,
        19,
        38,
        39,
        11,
        1,
        32,
        25,
        35,
        8,
        17,
        7,
        9,
        4,
        2,
        34,
        10,
        3
      ]

      chain = Day10.adapter_chain(example2)

      assert Day10.differences(chain) == %{
               1 => 22,
               3 => 10
             }
    end

    test "differences/1 on input file" do
      chain = Day10.parse!("test/data/day10_input.txt")
      assert Day10.differences(chain) == %{1 => 66, 3 => 39}
    end
  end

  describe "part 2" do
  end
end
