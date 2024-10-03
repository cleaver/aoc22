import AOC

aoc 2022, 4 do
  @moduledoc """
  https://adventofcode.com/2022/day/4
  """
  import InputHelpers
  alias __MODULE__.Parser

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    input
    |> parse_input()
    |> Enum.map(fn line ->
      line
      |> parse_line()
      |> count_subset()
    end)
    |> Enum.sum()
  end

  def count_subset([[e1_start, _] = elf_1, [e2_start, _] = elf_2]) when e1_start > e2_start,
    do: count_subset([elf_2, elf_1])

  def count_subset([[e1_start, e1_end], [e2_start, e2_end]])
      when e1_start == e2_start or e1_end == e2_end,
      do: 1

  def count_subset([[_, e1_end], [_, e2_end]]) when e1_end >= e2_end,
    do: 1

  def count_subset(_), do: 0

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    input
    |> parse_input()
    |> Enum.map(fn line ->
      line
      |> parse_line()
      |> count_overlap()
    end)
    |> Enum.sum()
  end

  def count_overlap([[e1_start, _] = elf_1, [e2_start, _] = elf_2]) when e1_start > e2_start,
    do: count_overlap([elf_2, elf_1])

  def count_overlap([[_, e1_end], [e2_start, _]]) when e1_end < e2_start,
    do: 0

  def count_overlap(_), do: 1

  defp parse_line(line) do
    {:ok, result, _, _, _, _} = Parser.elf_assignment(line)
    Enum.chunk_every(result, 2)
  end
end
