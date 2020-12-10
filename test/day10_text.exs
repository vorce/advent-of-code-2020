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
    test "differences/1 on example1 variants" do
      assert Day10.differences([0, 1, 4, 5, 7, 10, 11, 12, 15, 16, 19, 22]) == %{
               1 => 5,
               2 => 1,
               3 => 5
             }

      assert Day10.differences([0, 1, 4, 5, 7, 10, 12, 15, 16, 19, 22]) == %{
               1 => 3,
               2 => 2,
               3 => 5
             }

      assert Day10.differences([0, 1, 4, 6, 7, 10, 11, 12, 15, 16, 19, 22]) == %{
               1 => 5,
               2 => 1,
               3 => 5
             }

      assert Day10.differences([0, 1, 4, 6, 7, 10, 12, 15, 16, 19, 22]) == %{
               1 => 3,
               2 => 2,
               3 => 5
             }

      assert Day10.differences([0, 1, 4, 7, 10, 11, 12, 15, 16, 19, 22]) == %{1 => 4, 3 => 6}
      assert Day10.differences([0, 1, 4, 7, 10, 12, 15, 16, 19, 22]) == %{1 => 2, 2 => 1, 3 => 6}
      # All maps have total of: 22 (1*n + 2*m + 3*o)
    end

    # test "chain_sum" do
    # can you swap out any "1 difference" adapter to a 2? remove it?
    # only if its diff to the left and right element stays within 3.
    # O(n)? Go through each entry in the longest chain.
    # end

    test "canidates/2" do
      chain = Day10.adapter_chain(@part1_example_input)
      assert Day10.candidates(chain, 0) == [1]
      assert Day10.candidates(chain, 1) == [4]
      assert Day10.candidates(chain, 4) == [5, 6, 7]
    end
  end
end
