defmodule Aoc2020.Day10 do
  @moduledoc false

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

  def paths(chain) do
    target = Enum.reverse(chain) |> List.first()

    chain
    |> Enum.reverse()
    |> Enum.drop(1)
    |> Enum.reduce(%{target => 1}, fn adapter, acc ->
      paths_to_adapter = adapter_paths(acc, adapter)
      Map.put(acc, adapter, paths_to_adapter)
    end)
  end

  defp adapter_paths(paths, adapter) do
    Map.get(paths, adapter + 1, 0) + Map.get(paths, adapter + 2, 0) +
      Map.get(paths, adapter + 3, 0)
  end
end
