defmodule Aoc2020.Day10 do
  @moduledoc false

  defstruct [:chosen, :max]

  def parse!(path) do
    path
    |> File.stream!()
    |> Stream.map(fn line -> String.trim(line) end)
    |> Stream.reject(fn line -> line == "" end)
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
    |> adapter_chain()
  end

  def adapter_chain(input) do
    first = 0
    last = Enum.max(input) + 3
    Enum.sort([first, last | input])
  end

  def of(0), do: 1
  def of(n) when n > 0, do: n * of(n - 1)

  def differences(chain) do
    chain
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
    |> Enum.reduce(%{}, fn diff, acc ->
      Map.update(acc, diff, 1, fn ev ->
        ev + 1
      end)
    end)
  end

  def candidates(input, adapter) do
    Enum.filter(input, fn a -> a > adapter and a <= adapter + 3 end)
  end
end
