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
end
