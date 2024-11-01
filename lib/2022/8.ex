import AOC

aoc 2022, 8 do
  @moduledoc """
  https://adventofcode.com/2022/day/8
  """
  import InputHelpers
  alias Y2022.D8.ViewHelper
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
    map =
      input
      |> parse_input()
      |> Enum.map(&parse_line/1)
      |> Nx.tensor()

    _row_views =
      map
      |> Nx.vectorize(:rows)
      |> ViewHelper.view_score()
  end

  defmodule ViewHelper do
    import Nx.Defn
    require Nx
    alias Nx

    defn view_score(tensor) do
      slice_length =
        case Nx.shape(tensor) do
          {length} -> length
          _ -> raise "invalid shape"
        end

      {_, acc} =
        while {tensor, acc = Nx.broadcast(0, {slice_length})},
              index <- 1..(Nx.axis_size(tensor, 0) - 2) do
          {tensor, tree_view(tensor, index, acc)}
        end

      acc
    end

    # [1, 2, 3, 4, 5], 1, [0, 0, 0, 0, 0]
    defn tree_view(tensor, index, acc_vector) do
      vector_view_product =
        tensor
        |> Nx.less(tensor[index])
        |> view_left_and_right(index)

      Nx.indexed_put(acc_vector, vector_view_product, index)
    end

    defn view_left_and_right(tensor, index) do
      {_, _, right_view} =
        while {tensor, current = index + 1, acc = 1}, test_right(tensor, current) do
          {tensor, current, acc + 1}
        end

      {_, _, left_view} =
        while {tensor, current = index - 1, acc = 1}, test_left(tensor, current) do
          {tensor, current, acc + 1}
        end

      left_view * right_view
    end

    defn test_right(tensor, index) do
      inspectum("before")

      if Nx.greater_equal(index, Nx.axis_size(tensor, 0) - 1) do
        inspectum("after")
        tensor[index]
      else
        inspectum("after 0")
        0
      end
    end

    defn test_left(tensor, index) do
      if Nx.greater_equal(index, 0) do
        tensor[index]
      else
        0
      end
    end

    deftransform(inspectum(data, label \\ ""))

    # deftransform inspectum(data, label) when Nx.is_tensor(data) do
    #   if Nx.shape(data) == {} do
    #     Nx.to_number(data)
    #   else
    #     Nx.to_list(data)
    #   end
    #   |> IO.inspect(label: label)
    # end

    deftransform inspectum(data, label) do
      IO.inspect(data, label: label)
    end
  end

  defp parse_line(line) do
    line
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end
end
