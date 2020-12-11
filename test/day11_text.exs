defmodule Aoc2020.Day11Test do
  use ExUnit.Case

  alias Aoc2020.Day11

  @start_example [
    "L.LL.LL.LL",
    "LLLLLLL.LL",
    "L.L.L..L..",
    "LLLL.LL.LL",
    "L.LL.LL.LL",
    "L.LLLLL.LL",
    "..L.L.....",
    "LLLLLLLLLL",
    "L.LLLLLL.L",
    "L.LLLLL.LL"
  ]

  describe "part 1" do
    test "parse/1" do
      result = Day11.parse!(@start_example)
      assert Map.get(result, {0, 0}) == "L"
      assert Map.get(result, {9, 9}) == "L"
      assert Map.get(result, {5, 2}) == "."
    end

    test "iterate/2 once on example" do
      map = Day11.parse!(@start_example)
      empty_seat_fn = &Day11.no_occupied_adjacent?/2
      occupied_seat_fn = &Day11.crowded?/2

      result = Day11.iterate(map, empty_seat_fn, occupied_seat_fn)

      Enum.each(result, fn {pos, v} ->
        case Map.get(map, pos) do
          "L" -> assert v == "#"
          "." -> assert v == "."
        end
      end)
    end

    test "iterate/2 twice on example" do
      map = Day11.parse!(@start_example)
      empty_seat_fn = &Day11.no_occupied_adjacent?/2
      occupied_seat_fn = &Day11.crowded?/2

      result =
        map
        |> Day11.iterate(empty_seat_fn, occupied_seat_fn)
        |> Day11.iterate(empty_seat_fn, occupied_seat_fn)

      assert Map.get(result, {2, 0}) == "L"
      assert Map.get(result, {6, 5}) == "#"
    end

    test "iterate_until_done on input file" do
      map =
        "test/data/day11_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Day11.parse!()

      empty_seat_fn = &Day11.no_occupied_adjacent?/2
      occupied_seat_fn = &Day11.crowded?/2

      result = Day11.iterate_until_done(map, %{}, empty_seat_fn, occupied_seat_fn)

      assert Day11.count_occupied_seats(result) == 2346
    end

    test "iterate_until_done on example" do
      map = Day11.parse!(@start_example)

      expected_result = [
        "#.#L.L#.##",
        "#LLL#LL.L#",
        "L.#.L..#..",
        "#L##.##.L#",
        "#.#L.LL.LL",
        "#.#L#L#.##",
        "..L.L.....",
        "#L#L##L#L#",
        "#.LLLLLL.L",
        "#.#L#L#.##"
      ]

      empty_seat_fn = &Day11.no_occupied_adjacent?/2
      occupied_seat_fn = &Day11.crowded?/2

      result = Day11.iterate_until_done(map, %{}, empty_seat_fn, occupied_seat_fn)
      assert Day11.output(result, 10, 10) == expected_result
    end
  end

  @part2_example [
    ".......#.",
    "...#.....",
    ".#.......",
    ".........",
    "..#L....#",
    "....#....",
    ".........",
    "#........",
    "...#....."
  ]
  describe "part 2" do
    test "find_adjacent_seen/2 on example" do
      map = Day11.parse!(@part2_example)
      assert Day11.find_adjacent_seen(map, {3, 4}, {-1, 0}, []) == ["#"]
      assert Day11.find_adjacent_seen(map, {3, 4}, {0, -1}, []) == ["#"]
      assert Day11.find_adjacent_seen(map, {3, 4}, {0, 1}, []) == ["#"]
      assert Day11.find_adjacent_seen(map, {3, 4}, {1, 0}, []) == ["#"]
      assert Day11.find_adjacent_seen(map, {3, 4}, {-1, -1}, []) == ["#"]
      assert Day11.find_adjacent_seen(map, {3, 4}, {-1, 1}, []) == ["#"]
      assert Day11.find_adjacent_seen(map, {3, 4}, {1, -1}, []) == ["#"]
      assert Day11.find_adjacent_seen(map, {3, 4}, {1, 1}, []) == ["#"]
    end

    test "find_adjacent_seen/2 on example 2" do
      example2 = [
        ".............",
        ".L.L.#.#.#.#.",
        "............."
      ]

      map = Day11.parse!(example2)
      start_pos = {1, 1}
      assert Day11.find_adjacent_seen(map, start_pos, {-1, 0}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {0, -1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {0, 1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {1, 0}, []) == ["L"]
      assert Day11.find_adjacent_seen(map, start_pos, {-1, -1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {-1, 1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {1, -1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {1, 1}, []) == []
    end

    test "find_adjacent_seen/2 on example 3" do
      example3 = [
        ".##.##.",
        "#.#.#.#",
        "##...##",
        "...L...",
        "##...##",
        "#.#.#.#",
        ".##.##."
      ]

      map = Day11.parse!(example3)
      start_pos = {3, 3}
      assert Day11.find_adjacent_seen(map, start_pos, {-1, 0}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {0, -1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {0, 1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {1, 0}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {-1, -1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {-1, 1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {1, -1}, []) == []
      assert Day11.find_adjacent_seen(map, start_pos, {1, 1}, []) == []
    end

    test "iterate/2 once on example" do
      map = Day11.parse!(@start_example)

      expected_result = [
        "#.##.##.##",
        "#######.##",
        "#.#.#..#..",
        "####.##.##",
        "#.##.##.##",
        "#.#####.##",
        "..#.#.....",
        "##########",
        "#.######.#",
        "#.#####.##"
      ]

      empty_seat_fn = &Day11.no_occupied_adjacent_seen?/2
      occupied_seat_fn = &Day11.crowded_seen?/2

      result = Day11.iterate(map, empty_seat_fn, occupied_seat_fn)

      assert Day11.output(result, 10, 10) == expected_result
    end

    test "iterate/2 twice on example" do
      map = Day11.parse!(@start_example)

      expected_result = [
        "#.LL.LL.L#",
        "#LLLLLL.LL",
        "L.L.L..L..",
        "LLLL.LL.LL",
        "L.LL.LL.LL",
        "L.LLLLL.LL",
        "..L.L.....",
        "LLLLLLLLL#",
        "#.LLLLLL.L",
        "#.LLLLL.L#"
      ]

      empty_seat_fn = &Day11.no_occupied_adjacent_seen?/2
      occupied_seat_fn = &Day11.crowded_seen?/2

      result =
        map
        |> Day11.iterate(empty_seat_fn, occupied_seat_fn)
        |> Day11.iterate(empty_seat_fn, occupied_seat_fn)

      assert Day11.output(result, 10, 10) == expected_result
    end

    test "iterate_until_done on example" do
      map = Day11.parse!(@start_example)

      expected_result = [
        "#.L#.L#.L#",
        "#LLLLLL.LL",
        "L.L.L..#..",
        "##L#.#L.L#",
        "L.L#.LL.L#",
        "#.LLLL#.LL",
        "..#.L.....",
        "LLL###LLL#",
        "#.LLLLL#.L",
        "#.L#LL#.L#"
      ]

      empty_seat_fn = &Day11.no_occupied_adjacent_seen?/2
      occupied_seat_fn = &Day11.crowded_seen?/2

      result = Day11.iterate_until_done(map, %{}, empty_seat_fn, occupied_seat_fn)

      assert Day11.output(result, 10, 10) == expected_result
    end

    test "iterate_until_done on input file" do
      map =
        "test/data/day11_input.txt"
        |> File.read!()
        |> String.split("\n")
        |> Day11.parse!()

      empty_seat_fn = &Day11.no_occupied_adjacent_seen?/2
      occupied_seat_fn = &Day11.crowded_seen?/2

      result = Day11.iterate_until_done(map, %{}, empty_seat_fn, occupied_seat_fn)

      assert Day11.count_occupied_seats(result) == 2111
    end
  end
end
