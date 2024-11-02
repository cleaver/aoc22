import AOC

aoc 2022, 8 do
  @moduledoc """
  https://adventofcode.com/2022/day/8
  """
  import InputHelpers
  alias MapSetAgent
  alias Nx
  @tree_agent :tree_agent

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    map =
      input
      |> parse_input()
      |> Enum.map(&parse_line/1)
      |> Nx.tensor()

    # |> Nx.slice([0, 2], [5, 1])
    # |> Nx.to_flat_list()
    {rows, cols} = Nx.shape(map)

    MapSetAgent.start(@tree_agent)
    add_outside_trees(rows, cols)
    scan_rows(map, rows, cols)
    scan_cols(map, rows, cols)

    visible_trees = MapSetAgent.size(@tree_agent)
    MapSetAgent.stop(@tree_agent)
    visible_trees
  end

  defp add_outside_trees(rows, cols) do
    Enum.each(0..(cols - 1), fn col ->
      MapSetAgent.put({0, col}, @tree_agent)
      MapSetAgent.put({rows - 1, col}, @tree_agent)
    end)

    Enum.each(1..(rows - 2), fn row ->
      MapSetAgent.put({row, 0}, @tree_agent)
      MapSetAgent.put({row, cols - 1}, @tree_agent)
    end)
  end

  defp scan_rows(map, rows, cols) do
    Enum.each(1..(rows - 2), fn row ->
      Nx.slice(map, [row, 0], [1, cols])
      |> Nx.to_flat_list()
      |> filter_visible()
      |> Enum.each(fn col ->
        MapSetAgent.put({row, col}, @tree_agent)
      end)
    end)
  end

  defp scan_cols(map, rows, cols) do
    Enum.each(1..(cols - 2), fn col ->
      Nx.slice(map, [0, col], [rows, 1])
      |> Nx.to_flat_list()
      |> filter_visible()
      |> Enum.each(fn row ->
        MapSetAgent.put({row, col}, @tree_agent)
      end)
    end)
  end

  defp filter_visible(vector) do
    vector = Enum.with_index(vector)

    {_, visible_from_start} = vector |> visible_in_line()
    {_, visible_from_end} = vector |> Enum.reverse() |> visible_in_line()

    Enum.uniq(visible_from_start ++ visible_from_end)
  end

  defp visible_in_line(vector) do
    Enum.reduce_while(vector, {0, []}, fn {height, index}, {max_height, visible_trees} = acc ->
      cond do
        height == 9 -> {:halt, {height, [index | visible_trees]}}
        height > max_height -> {:cont, {height, [index | visible_trees]}}
        true -> {:cont, acc}
      end
    end)
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    list_map =
      input
      |> parse_input()
      |> Enum.map(&parse_line/1)

    IO.inspect(list_map |> Nx.tensor(), label: "list_map")

    row_views =
      list_map
      |> remove_first_and_last()
      |> Enum.map(&view_score/1)
      |> Nx.tensor()
      |> Nx.pad(0, [{1, 1, 0}, {0, 0, 0}])

    col_views =
      list_map
      |> Nx.tensor()
      |> Nx.transpose()
      |> Nx.to_list()
      |> remove_first_and_last()
      |> Enum.map(&view_score/1)
      |> Nx.tensor()
      |> Nx.pad(0, [{1, 1, 0}, {0, 0, 0}])
      |> Nx.transpose()

    Nx.multiply(row_views, col_views)
    |> Nx.reduce_max()
  end

  defp remove_first_and_last(list_map), do: Enum.slice(list_map, 1..-2//1)

  defp view_score(row) do
    row
    |> Enum.with_index()
    |> Enum.map(&view_score_at(&1, row))
  end

  defp view_score_at({_, 0}, _), do: 0
  defp view_score_at({_, index}, row) when index >= length(row) - 1, do: 0

  defp view_score_at({height, index}, row) do
    right_score =
      row
      |> Enum.slice((index + 1)..-1//1)
      |> count_visible_trees(height)

    left_score =
      row
      |> Enum.reverse()
      |> Enum.slice((length(row) - index)..-1//1)
      |> count_visible_trees(height)

    right_score * left_score
  end

  defp count_visible_trees(trees, height) do
    Enum.reduce_while(trees, 0, fn tree, acc ->
      if tree < height, do: {:cont, acc + 1}, else: {:halt, acc + 1}
    end)
  end

  defp parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end
end
