defmodule Aoc2020.Day6 do
  @moduledoc """
  Day 6
  """

  @doc """
  Returns the combined, unique, answers for a group.
  """
  @spec combined_answers(group :: [String.t()]) :: MapSet.t()
  def combined_answers(group) do
    Enum.reduce(group, MapSet.new(), fn questions, acc ->
      questions
      |> person_questions()
      |> MapSet.union(acc)
    end)
  end

  @spec person_questions(questions :: String.t()) :: MapSet.t()
  def person_questions(questions) do
    questions
    |> String.codepoints()
    |> Enum.reduce(MapSet.new(), fn question, acc ->
      MapSet.put(acc, question)
    end)
  end

  @doc """
  Returns the sum of each input group's answers.
  The group's answers is determined by the set returned by `group_count_fn/1`.
  """
  @spec sum_answers(input :: [String.t()], group_count_fn :: Function.t()) :: integer()
  def sum_answers(input, group_count_fn) do
    input
    |> Enum.chunk_by(fn i -> i == "" end)
    |> Enum.reject(fn group -> group == [""] end)
    |> Enum.map(fn group -> group |> group_count_fn.() |> MapSet.size() end)
    |> Enum.sum()
  end

  @doc """
  Returns the answers that are in common for each person in the group.
  """
  @spec common_answers(group :: [String.t()]) :: MapSet.t()
  def common_answers(group) do
    [first | rest] = group

    Enum.reduce(rest, person_questions(first), fn questions, acc ->
      questions
      |> person_questions()
      |> MapSet.intersection(acc)
    end)
  end
end
