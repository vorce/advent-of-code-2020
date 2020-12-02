defmodule Aoc2020.Day2Test do
  use ExUnit.Case

  alias Aoc2020.Day2

  describe "part1" do
    test "example" do
      passwords = [
        %{range: 1..3, char: "a", password: "abcde"},
        %{range: 1..3, char: "b", password: "cdefg"},
        %{range: 2..9, char: "c", password: "ccccccccc"}
      ]

      assert Day2.valid(passwords) == [
               %{range: 1..3, char: "a", password: "abcde"},
               %{range: 2..9, char: "c", password: "ccccccccc"}
             ]
    end

    test "parse line" do
      line = "15-16 l: klfbblslvjclmlnqklvg"

      assert Day2.parse_line(line) == %{
               range: 15..16,
               char: "l",
               password: "klfbblslvjclmlnqklvg"
             }
    end

    test "valid big file" do
      parsed_passwords = Day2.parse!("test/data/day2_input.txt")

      valid_passwords = Day2.valid(parsed_passwords)

      # 330: That's not the right answer; your answer is too low
      assert length(valid_passwords) == 424
    end
  end
end
