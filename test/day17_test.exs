defmodule Aoc2020.Day17Test do
  use ExUnit.Case

  alias Aoc2020.Day17

  describe "part 1" do
    test "parse" do
      inp = [
        ".#.",
        "..#",
        "###"
      ]

      assert Day17.parse(inp) == %{
               {0, 0, 0} => ".",
               {1, 0, 0} => "#",
               {2, 0, 0} => ".",
               {0, 1, 0} => ".",
               {1, 1, 0} => ".",
               {2, 1, 0} => "#",
               {0, 2, 0} => "#",
               {1, 2, 0} => "#",
               {2, 2, 0} => "#"
             }
    end

    test "next" do
      start =
        [
          ".#.",
          "..#",
          "###"
        ]
        |> Day17.parse()

      assert Day17.tick(start) == %{
               {0, 0, 0} => ".",
               {1, 0, 0} => ".",
               {2, 0, 0} => ".",
               {0, 1, 0} => "#",
               {1, 1, 0} => ".",
               {2, 1, 0} => "#",
               {0, 2, 0} => ".",
               {1, 2, 0} => "#",
               {2, 2, 0} => "#"
             }
    end
  end

  describe "part 2" do
  end
end
