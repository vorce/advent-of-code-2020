defmodule Aoc2020.Day13 do
  def parse!([now | buses]) do
    now = String.to_integer(now)

    buses =
      buses
      |> Enum.join()
      |> String.split(",")
      |> Enum.reject(fn bus -> bus == "x" end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort()

    %{now: now, candidates: buses}
  end

  def earliest_bus(schedule) do
    Enum.reduce(schedule.candidates, {-1, 9_999_999_999}, fn bus, {_, min} = acc ->
      bus_departure = bus_after_now(bus, schedule.now, schedule.now)
      if bus_departure < min, do: {bus, bus_departure}, else: acc
    end)
  end

  def bus_after_now(bus, earliest_possible_time, timestamp) do
    departure = div(timestamp, bus) * bus

    if departure >= earliest_possible_time do
      departure
    else
      bus_after_now(bus, earliest_possible_time, timestamp + 1)
    end
  end

  def wait_id(now, {bus, departure}) do
    (departure - now) * bus
  end

  def parse2!([_now | buses]) do
    buses
    |> Enum.join()
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.reject(fn {bus, _index} -> bus == "x" end)
    |> Enum.into(%{}, fn {bus, index} ->
      {index, String.to_integer(bus)}
    end)
  end

  def candidates(requirements, start \\ 0) do
    reqs =
      requirements
      |> Enum.sort_by(fn {_o, b} -> b end)
      |> Enum.reverse()

    {offset, bus} = hd(reqs)
    remaining_requirements = Enum.drop(reqs, 1)

    Stream.iterate(start, &(&1 + bus))
    |> Stream.reject(fn timestamp -> invalid?(timestamp, remaining_requirements, offset) end)
    |> Stream.map(fn timestamp -> timestamp - offset end)
  end

  def find_two_slowest({offset1, bus1}, {offset2, bus2}) do
    Stream.iterate(0, &(&1 + bus1))
    |> Stream.reject(fn timestamp ->
      if offset2 > offset1 do
        rem(timestamp + (offset2 - offset1), bus2) != 0
      else
        rem(timestamp - (offset1 - offset2), bus2) != 0
      end
    end)
  end

  # I did not find this solution myself.
  def find_with_maths(reqs) do
    product =
      Enum.reduce(reqs, 1, fn {_offset, bus}, acc ->
        bus * acc
      end)

    sum =
      reqs
      |> Enum.map(fn {offset, bus} ->
        product_without_id = div(product, bus)
        mod_inverse = inverse(product_without_id, bus)
        (bus - rem(offset, bus)) * product_without_id * mod_inverse
      end)
      |> Enum.sum()

    rem(sum, product)
  end

  def invalid?(timestamp, requirements, top_offset) do
    Enum.any?(requirements, fn {offset, bus} ->
      if offset > top_offset do
        rem(timestamp + (offset - top_offset), bus) != 0
      else
        rem(timestamp - (top_offset - offset), bus) != 0
      end
    end)
  end

  ### From rosetta code on how to find modular inverse
  # https://rosettacode.org/wiki/Modular_inverse#Elixir

  def extended_gcd(a, b) do
    {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
    {last_remainder, last_x * if(a < 0, do: -1, else: 1)}
  end

  defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}

  defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
    quotient = div(last_remainder, remainder)
    remainder2 = rem(last_remainder, remainder)
    extended_gcd(remainder, remainder2, x, last_x - quotient * x, y, last_y - quotient * y)
  end

  def inverse(e, et) do
    {g, x} = extended_gcd(e, et)
    if g != 1, do: raise("The maths are broken!")
    rem(x + et, et)
  end
end
