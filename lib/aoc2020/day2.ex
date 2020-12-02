defmodule Aoc2020.Day2 do
  @moduledoc """
  --- Day 2: Password Philosophy ---

  Your flight departs in a few days from the coastal airport; the easiest way down to the coast from here is via toboggan.

  The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's wrong with our computers; we can't log in!" You ask if you can take a look.

  Their password database seems to be a little corrupted: some of the passwords wouldn't have been allowed by the Official Toboggan Corporate Policy that was in effect when they were chosen.

  To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.

  For example, suppose you have the following list:

  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc

  Each line gives the password policy and then the password. The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid. For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

  In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.

  How many passwords are valid according to their policies?

  """

  def list_valid_passwords(path, part) do
    part1_validation_fn = &valid_password/1
    part2_validation_fn = &valid_password2/1

    validation_fn =
      case part do
        :part1 -> part1_validation_fn
        :part2 -> part2_validation_fn
      end

    path
    |> parse!()
    |> validate(validation_fn)
  end

  def validate(passwords, validatefn) do
    passwords
    |> Enum.filter(validatefn)
  end

  def valid_password(%{position1: pos1, position2: pos2, char: character, password: password}) do
    codepoints = String.graphemes(password)
    character_count = Enum.count(codepoints, fn c -> c == character end)

    character_count in pos1..pos2
  end

  def parse!(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.reject(fn l -> l == "" end)
    |> Enum.map(&parse_line/1)
  end

  def valid_password2(%{position1: pos1, position2: pos2, char: character, password: password}) do
    codepoints = String.graphemes(password)
    pos1_char = Enum.at(codepoints, pos1 - 1)
    pos2_char = Enum.at(codepoints, pos2 - 1)

    cond do
      pos1_char == character and pos2_char != character -> true
      pos2_char == character and pos1_char != character -> true
      true -> false
    end
  end

  def parse_line(line) do
    [pos1, rest] = String.split(line, "-", parts: 2)
    pos1 = String.to_integer(pos1)
    [pos2, char, pwd] = String.split(rest, " ", parts: 3)
    pos2 = String.to_integer(pos2)
    char = String.replace_suffix(char, ":", "")

    %{position1: pos1, position2: pos2, char: char, password: pwd}
  end
end
