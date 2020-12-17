defmodule Aoc2020.Day16 do
  def parse_nearby(lines) do
    Enum.map(lines, &parse_ticket_line/1)
  end

  def parse_ticket_line(line) do
    String.split(line, ",")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_rules(lines) do
    Enum.map(lines, &parse_rule_line/1)
  end

  def parse_rule_line(line) do
    [first, second] =
      line
      |> String.split(": ", parts: 2)
      |> Enum.drop(1)
      |> hd()
      |> String.split(" or ")

    [parse_rule_range(first), parse_rule_range(second)]
  end

  def parse_rule_range(range) do
    [r1, r2] = String.split(range, "-", parts: 2)
    String.to_integer(r1)..String.to_integer(r2)
  end

  def invalid(rules, ticket) do
    # perms = permutations(rules)
    # nr_rules = length(rules)

    Enum.reduce(ticket, [], fn ticket_nr, acc ->
      case Enum.any?(rules, fn [r1, r2] -> ticket_nr in r1 or ticket_nr in r2 end) do
        false -> [ticket_nr | acc]
        true -> acc
      end
    end)
  end

  def sum_invalid(rules, tickets) do
    Enum.reduce(tickets, [], fn t, acc ->
      acc ++ invalid(rules, t)
    end)
    |> Enum.sum()
  end

  def determine() do
    """
    class: 0-1 or 4-19
    row: 0-5 or 8-19
    seat: 0-13 or 16-19

    your ticket:
    11,12,13

    nearby tickets:
    3,9,18
    15,1,5
    5,14,9
    """

    # rule[0] = [0..1, 4..19]
    # rule[1] = [0..5, 8..19]
    # ...
    # rule[n] = [r1i..r2i, r1j..r2j]
    #
    # col[0] = rule[k] such that each ticket[i][0] = within rule[k][0] or rule[k][1]
    # can we rule out a column?
    # find_rule_col():
    # for each ticket t:
    #   [t-valid-for-rule[0]]
  end

  def ticket_column([r1, r2], tickets, taken) do
    Enum.map(tickets, fn ticket ->
      ticket
      |> Enum.with_index()
      |> Enum.map(fn {nr, i} ->
        {nr in r1 or nr in r2, i}
      end)
    end)
    |> Enum.reject(fn matches -> Enum.any?(matches, fn {m, _i} -> m == false end) end)
    |> Enum.flat_map(fn matches -> Enum.map(matches, fn {_m, i} -> i end) end)
  end

  def distribute_columns(candidates) do
    Enum.sort(candidates, fn {_, c1}, {_, c2} ->
      length(c1) < length(c2)
    end)
    |> Enum.reduce(%{}, fn {col, cs}, acc ->
      c = first_available(acc, cs)
      # IO.inspect([col: col, candidates: cs, first_available: c, acc: acc], label: "map to cols")
      Map.put(acc, c, col)
    end)
  end

  def first_available(acc, cs) do
    Enum.find(cs, fn c -> not Map.has_key?(acc, c) end)
  end

  def candidates(rules, nearby) do
    rules
    |> Enum.with_index()
    |> Enum.map(fn {rule, i} ->
      {i, ticket_column(rule, nearby, [])}
    end)
  end
end
