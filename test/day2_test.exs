defmodule Aoc2020.Day2Test do
  use ExUnit.Case

  alias Aoc2020.Day2

  describe "part1" do
    test "example" do
      passwords = [
        %{position1: 1, position2: 3, char: "a", password: "abcde"},
        %{position1: 1, position2: 3, char: "b", password: "cdefg"},
        %{position1: 2, position2: 9, char: "c", password: "ccccccccc"}
      ]

      assert Day2.validate(passwords, &Day2.valid_password/1) == [
               %{position1: 1, position2: 3, char: "a", password: "abcde"},
               %{position1: 2, position2: 9, char: "c", password: "ccccccccc"}
             ]
    end

    test "parse line" do
      line = "15-16 l: klfbblslvjclmlnqklvg"

      assert Day2.parse_line(line) == %{
               position1: 15,
               position2: 16,
               char: "l",
               password: "klfbblslvjclmlnqklvg"
             }
    end

    test "input file" do
      valid_passwords = Day2.list_valid_passwords("test/data/day2_input.txt", :part1)
      assert length(valid_passwords) == 424
    end
  end

  describe "part 2" do
    test "example" do
      passwords = [
        %{position1: 1, position2: 3, char: "a", password: "abcde"},
        %{position1: 1, position2: 3, char: "b", password: "cdefg"},
        %{position1: 2, position2: 9, char: "c", password: "ccccccccc"}
      ]

      assert Day2.validate(passwords, &Day2.valid_password2/1) == [
               %{position1: 1, position2: 3, char: "a", password: "abcde"}
             ]
    end

    test "input file" do
      valid_passwords = Day2.list_valid_passwords("test/data/day2_input.txt", :part2)
      assert length(valid_passwords) == 747
    end
  end
end
