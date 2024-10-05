import AOC

aoc 2022, 6 do
  @moduledoc """
  https://adventofcode.com/2022/day/6
  """

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    marker_length = 4

    input
    |> find_marker(marker_length)
    |> Kernel.+(marker_length)
  end

  defp find_marker(message, marker_length) do
    Enum.reduce_while(0..String.length(message), nil, fn i, _acc ->
      candidate_marker = String.slice(message, i, marker_length)

      if non_duplicate?(candidate_marker) do
        {:halt, i}
      else
        {:cont, nil}
      end
    end)
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    marker_length = 14

    input
    |> find_marker(marker_length)
    |> Kernel.+(marker_length)
  end

  defp non_duplicate?(string) do
    string
    |> String.graphemes()
    |> Enum.uniq()
    |> length()
    |> Kernel.==(String.length(string))
  end
end
