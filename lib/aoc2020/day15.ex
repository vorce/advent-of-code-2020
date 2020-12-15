defmodule Aoc2020.Day15 do
  def number(start_numbers, turn_target) do
    start_nr_count = length(start_numbers)

    numbers_to_turns =
      Enum.with_index(start_numbers)
      |> Enum.into(%{}, fn {elem, index} -> {elem, [index + 1]} end)

    turns_to_numbers =
      Enum.with_index(start_numbers)
      |> Enum.into(%{}, fn {elem, index} -> {index + 1, elem} end)

    if turn_target <= start_nr_count do
      Map.get(turns_to_numbers, turn_target)
    else
      last_spoken =
        Enum.reverse(start_numbers)
        |> List.first()

      turn = start_nr_count + 1
      next_turn(numbers_to_turns, last_spoken, turn, turn_target)
    end
  end

  def next_turn(numbers_to_turns, last_spoken, turn, turn_target) do
    if rem(turn, 100_000) == 0 do
      IO.puts("Turn #{turn}/#{turn_target} ...")
    end

    spoken = next_spoken(numbers_to_turns, last_spoken, turn)

    if turn == turn_target do
      spoken
    else
      next_turn(
        Map.update(numbers_to_turns, spoken, [turn], fn ts -> [turn, hd(ts)] end),
        spoken,
        turn + 1,
        turn_target
      )
    end
  end

  def next_spoken(numbers_to_turns, last_spoken, turn) do
    case Map.get(numbers_to_turns, last_spoken) do
      [_val] ->
        0

      [_first, val] ->
        last_turn = turn - 1
        last_turn - val
    end
  end
end
