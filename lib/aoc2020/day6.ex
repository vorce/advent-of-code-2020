defmodule Aoc2020.Day6 do
  @moduledoc """
  Day 6
  """

  def count_group(group) do
    Enum.reduce(group, MapSet.new(), fn questions, acc ->
      questions
      |> person_questions()
      |> MapSet.union(acc)
    end)
  end

  def person_questions(questions) do
    questions
    |> String.codepoints()
    |> Enum.reduce(MapSet.new(), fn question, acc ->
      MapSet.put(acc, question)
    end)
  end

  def sum_answers(input, group_count_fn) do
    input
    |> Enum.chunk_by(fn i -> i == "" end)
    |> Enum.reject(fn group -> group == [""] end)
    |> Enum.map(fn group -> group |> group_count_fn.() |> MapSet.size() end)
    |> Enum.sum()
  end

  def count_group2(group) do
    [first | rest] = group

    Enum.reduce(rest, person_questions(first), fn questions, acc ->
      questions
      |> person_questions()
      |> MapSet.intersection(acc)
    end)
  end
end
