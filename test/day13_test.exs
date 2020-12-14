defmodule Aoc2020.Day13Test do
  use ExUnit.Case

  alias Aoc2020.Day13

  @example_notes [
    "939",
    "7,13,x,x,59,x,31,19"
  ]

  describe "part 1" do
    test "parse!/1" do
      assert Day13.parse!(@example_notes) == %{
               now: 939,
               candidates: [7, 13, 19, 31, 59]
             }
    end

    test "bus_after_now/2" do
      assert Day13.bus_after_now(7, 939, 939) == 945
      assert Day13.bus_after_now(13, 939, 939) == 949
      assert Day13.bus_after_now(19, 939, 939) == 950
      assert Day13.bus_after_now(31, 939, 939) == 961
      assert Day13.bus_after_now(59, 939, 939) == 944
    end

    test "earliest_bus/1 on example" do
      schedule = Day13.parse!(@example_notes)
      assert Day13.earliest_bus(schedule) == {59, 944}
    end

    test "bus_id/2" do
      assert Day13.wait_id(939, {59, 944}) == 295
    end

    test "bus_id/2 on input file" do
      schedule =
        "test/data/day13_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Day13.parse!()

      bus = Day13.earliest_bus(schedule)
      assert Day13.wait_id(schedule.now, bus) == 370
    end
  end

  describe "part 2" do
    test "parse2!/1" do
      assert Day13.parse2!(@example_notes) == %{
               0 => 7,
               1 => 13,
               4 => 59,
               6 => 31,
               7 => 19
             }
    end

    test "candidates/1" do
      assert Day13.candidates(%{0 => 7}) |> Stream.take(10) |> Enum.to_list() == [
               0,
               7,
               14,
               21,
               28,
               35,
               42,
               49,
               56,
               63
             ]

      assert Day13.candidates(%{0 => 7, 1 => 13}) |> Stream.take(10) |> Enum.to_list() == [
               77,
               168,
               259,
               350,
               441,
               532,
               623,
               714,
               805,
               896
             ]

      reqs = Day13.parse2!(@example_notes)
      assert Day13.candidates(reqs) |> Stream.take(1) |> Enum.to_list() == [1_068_781]
    end

    test "candidates/1 on examples" do
      reqs = %{
        0 => 17,
        # 1 => x
        2 => 13,
        3 => 19
      }

      assert Day13.candidates(reqs) |> Stream.take(1) |> Enum.to_list() == [3417]

      reqs = %{
        0 => 67,
        1 => 7,
        2 => 59,
        3 => 61
      }

      assert Day13.candidates(reqs) |> Stream.take(1) |> Enum.to_list() == [754_018]

      reqs = %{
        0 => 67,
        # 1 => x
        2 => 7,
        3 => 59,
        4 => 61
      }

      assert Day13.candidates(reqs) |> Stream.take(1) |> Enum.to_list() == [779_210]

      reqs = %{
        0 => 67,
        1 => 7,
        # 2 => x,
        3 => 59,
        4 => 61
      }

      assert Day13.candidates(reqs) |> Stream.take(1) |> Enum.to_list() == [1_261_476]

      reqs = %{
        0 => 1789,
        1 => 37,
        2 => 47,
        3 => 1889
      }

      assert Day13.candidates(reqs) |> Stream.take(1) |> Enum.to_list() == [1_202_161_486]
    end

    @tag timeout: :infinity
    test "candidates/1 on input file" do
      requirements =
        "test/data/day13_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Day13.parse2!()
        |> IO.inspect(label: "reqs")

      # assert 1 == 1
      reqs = %{29 => 631, 60 => 383, 70 => 41, 23 => 37, 0 => 29, 52 => 23, 48 => 19}
      # %{29 => 631, 60 => 383} = [211356, 453029, 694702]
      # %{29 => 631, 60 => 383, 70 => 41} = [5044816, 14953409, 24862002]
      # %{0 => 211356, 70 => 41} = [2536272, 11201868, 19867464]
      # assert Day13.candidates(reqs) |> Stream.take(3) |> Enum.to_list() == []
      # LCM(631, 383) = 241673
      # LCM(241673, 41) = 9908593
      # 5044816 + 9908593
      # Day13.iterate_with(requirements, 211_356) == 894_954_360_381_385
      #
      # %{29 => 631, 60 => 383, 70 => 41, 23 => 37, 0 => 29, 52 => 23}
      # Start timestamp: 203844620012
      # step_size: 244534166647

      # first hit: 211356
      # second hit: 211356 + lcm(631, 383) = 211356 + 241673 = 453029

      # [ts] = Day13.candidates(reqs) |> Stream.take(1) |> Enum.to_list()
      # IO.puts("Start timestamp: #{ts}")

      step_size =
        reqs
        |> Map.values()
        |> Enum.reduce(1, fn val, acc ->
          Day13.lcm(acc, val) |> round()
        end)
        |> IO.inspect(label: "step_size")

      # bla___ = 4_646_149_166_293
      # bla_40 = 185_845_966_651_720
      # foo___ = 894_954_360_381_385
      # #      1_026_798_965_750_753
      # assert 1 == 1
      foo = 929229833258600

      assert Day13.iterate_with(requirements, 0, step_size)
             |> Stream.take(1)
             |> Enum.to_list() ==
               [
                 894_954_360_381_385
                 929_229_833_258_60
               ]
    end

    test "find_two_slowest/2" do
      assert Day13.find_two_slowest({4, 59}, {6, 31}) |> Stream.take(1) |> Enum.to_list() == [649]

      assert Day13.find_two_slowest({29, 631}, {60, 383}) |> Stream.take(1) |> Enum.to_list() ==
               [211_385]
    end

    test "find_with_maths/1 on example" do
      reqs = Day13.parse2!(@example_notes)
      assert Day13.find_with_maths(reqs) == 1_068_781
    end

    test "find_with_maths/1 on input file" do
      requirements =
        "test/data/day13_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Day13.parse2!()

      assert Day13.find_with_maths(requirements) == 894_954_360_381_385
    end
  end
end
