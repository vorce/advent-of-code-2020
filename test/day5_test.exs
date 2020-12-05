defmodule Aoc2020.Day5Test do
  use ExUnit.Case

  alias Aoc2020.Day5

  describe "part 1" do
    test "code_to_position/3 example" do
      row_range = 0..127
      col_range = 0..7

      assert Day5.code_to_position("FBFBBFFRLR", row_range, col_range) == {44, 5}
      assert Day5.code_to_position("BFFFBBFRRR", row_range, col_range) == {70, 7}
      assert Day5.code_to_position("FFFBBBFRRR", row_range, col_range) == {14, 7}
      assert Day5.code_to_position("BBFFBBFRLL", row_range, col_range) == {102, 4}
    end

    test "find_pos/3 for rows" do
      row_range = 0..127
      mapping = %{lower: "F", upper: "B"}

      assert Day5.find_pos(["F", "B", "F", "B", "B", "F", "F"], row_range, mapping) == 44
      assert Day5.find_pos(["B", "F", "F", "F", "B", "B", "F"], row_range, mapping) == 70
    end

    test "find_pos/3 for columns" do
      row_range = 0..7
      mapping = %{lower: "L", upper: "R"}

      assert Day5.find_pos(["R", "L", "R"], row_range, mapping) == 5
    end

    test "highest_seat_id" do
      row_range = 0..127
      col_range = 0..7

      highest_seat_id =
        File.stream!("test/data/day5_input.txt")
        |> Stream.reject(fn line -> line == "\n" or line == "" end)
        |> Stream.map(fn line ->
          position = Day5.code_to_position(String.trim(line), row_range, col_range)
          Day5.seat_id(position)
        end)
        |> Enum.into([])
        |> Enum.max()

      assert highest_seat_id == 970
    end
  end

  describe "part 2" do
    test "missing_seats/3" do
      row_range = 0..127
      col_range = 0..7

      row =
        "test/data/day5_input.txt"
        |> Day5.missing_seats(row_range, col_range)
        |> Enum.drop(1)
        |> List.first()

      row_cols = Enum.map(row, fn {_row, col} -> col end)
      col = Enum.find(col_range, fn c -> c not in row_cols end)

      row = row |> hd() |> elem(0)

      assert {row, col} == {73, 3}
      assert Day5.seat_id({row, col}) == 587
    end
  end
end
