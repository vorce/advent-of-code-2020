defmodule Aoc2020.Day15Test do
  use ExUnit.Case

  alias Aoc2020.Day15

  describe "part 1" do
    test "example 1" do
      nrs = [0, 3, 6]
      assert Day15.number(nrs, 2020) == 436
    end

    test "example 2" do
      nrs = [1, 3, 2]
      assert Day15.number(nrs, 2020) == 1
    end

    test "example 3" do
      nrs = [2, 1, 3]
      assert Day15.number(nrs, 2020) == 10
    end

    test "example 4" do
      nrs = [1, 2, 3]
      assert Day15.number(nrs, 2020) == 27
    end

    test "example 5" do
      nrs = [2, 3, 1]
      assert Day15.number(nrs, 2020) == 78
    end

    test "example 6" do
      nrs = [3, 2, 1]
      assert Day15.number(nrs, 2020) == 438
    end

    test "example 7" do
      nrs = [3, 1, 2]
      assert Day15.number(nrs, 2020) == 1836
    end

    test "on input" do
      nrs = [14, 1, 17, 0, 3, 20]
      assert Day15.number(nrs, 2020) == 387
    end
  end

  describe "part 2" do
  end
end
