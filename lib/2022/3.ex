import AOC

aoc 2022, 3 do
  @moduledoc """
  https://adventofcode.com/2022/day/3
  """
  import InputHelpers

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    characters = character_map()

    input
    |> parse_input()
    |> Enum.map(fn line ->
      duplicate =
        line
        |> split_compartments()
        |> find_duplicate_naive()

      _value = Map.get(characters, duplicate)
    end)
    |> Enum.sum()
  end

  defp split_compartments(line) do
    String.split_at(line, Integer.floor_div(String.length(line), 2))
  end

  defp find_duplicate_naive({a, b}) do
    a
    |> String.graphemes()
    |> Enum.find(&String.contains?(b, &1))
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    characters = character_map()

    input
    |> parse_input()
    |> Enum.chunk_every(3)
    |> Enum.map(fn elf_group ->
      badge =
        elf_group
        |> Enum.map(fn elf_pack ->
          elf_pack
          |> String.graphemes()
          |> MapSet.new()
        end)
        |> find_common()
        |> MapSet.to_list()
        |> hd()

      Map.get(characters, badge)
    end)
    |> Enum.sum()
  end

  defp find_common([first | rest]) do
    Enum.reduce(rest, first, fn elf_pack, acc ->
      MapSet.intersection(acc, elf_pack)
    end)
  end

  def character_map do
    map =
      Enum.reduce(1..26, %{}, fn i, acc ->
        Map.put(acc, List.to_string([?a + i - 1]), i)
      end)

    Enum.reduce(27..52, map, fn i, acc ->
      Map.put(acc, List.to_string([?A + i - 27]), i)
    end)
  end
end
