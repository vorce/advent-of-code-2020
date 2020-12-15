defmodule Aoc2020.Day15 do
  def number(start_numbers, turn_target) do
    numbers_to_turns =
      Enum.with_index(start_numbers)
      |> Enum.into(%{}, fn {elem, index} -> {elem, [index + 1]} end)

    turns_to_numbers =
      Enum.with_index(start_numbers)
      |> Enum.into(%{}, fn {elem, index} -> {index + 1, elem} end)

    if turn_target < length(start_numbers) do
      Map.get(turns_to_numbers, turn_target)
    else
      last_spoken =
        Enum.reverse(start_numbers)
        |> List.first()

      turn = length(start_numbers) + 1
      do_next_turn(numbers_to_turns, turns_to_numbers, last_spoken, turn, turn_target)
    end
  end

  def do_next_turn(numbers_to_turns, turns_to_numbers, last_spoken, turn, turn_target) do
    IO.inspect(binding(), label: "Turn #{turn}")

    case Map.get(numbers_to_turns, last_spoken) do
      [_val] ->
        spoken = 0

        if turn == turn_target do
          spoken
        else
          do_next_turn(
            Map.update(numbers_to_turns, spoken, [turn], fn ts -> [turn, hd(ts)] end),
            Map.put(turns_to_numbers, turn, spoken),
            spoken,
            turn + 1,
            turn_target
          )
        end

      [_first, val] ->
        last_turn = turn - 1
        spoken = last_turn - val

        if turn == turn_target do
          spoken
        else
          do_next_turn(
            Map.update(numbers_to_turns, spoken, [turn], fn ts -> [turn, hd(ts)] end),
            Map.put(turns_to_numbers, turn, spoken),
            spoken,
            turn + 1,
            turn_target
          )
        end
    end
  end

  # if turn == turn_target do
  #   turn_nr
  # else
  #   case Map.get(numbers_to_turns, last_spoken) do
  #     nil -> 0
  #     val ->
  #   end
  #   do_next_turn(
  #     Map.put(numbers_to_turns, turn_nr, turn),
  #     Map.put(turns_to_numbers, turn, turn_nr),
  #     turn_nr,
  #     turn + 1,
  #     turn_target
  #   )
  # end
end
