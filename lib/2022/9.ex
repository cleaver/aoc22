import AOC

aoc 2022, 9 do
  @moduledoc """
  https://adventofcode.com/2022/day/9
  """

  import InputHelpers
  alias MapSetAgent

  @mapset_agent :mapset_agent

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    pull_rope(input, 2)
  end

  defp pull_rope(input, rope_length) do
    MapSetAgent.start(@mapset_agent)
    rope = fill_list({0, 0}, rope_length)

    input
    |> parse_input()
    |> Enum.map(&parse_line/1)
    |> execute_moves(rope)

    IO.inspect(MapSetAgent.dump(@mapset_agent), label: "MapSetAgent")
    size = MapSetAgent.size(@mapset_agent)
    MapSetAgent.stop(@mapset_agent)
    size
  end

  defp execute_moves([], rope), do: rope

  defp execute_moves([{_, 0} | rest], rope),
    do: execute_moves(rest, rope)

  defp execute_moves([{direction, distance} | rest], rope) do
    new_rope = move(direction, rope)
    execute_moves([{direction, distance - 1} | rest], new_rope)
  end

  defp move(direction, [rope_tail]) do
    new_tail = add_direction(direction, rope_tail)
    MapSetAgent.put(new_tail, @mapset_agent)
    [new_tail]
  end

  defp move(direction, [rope_head, rope_next | rest]) do
    new_head = add_direction(direction, rope_head)

    next_move =
      next_direction(new_head, rope_next)

    # |> IO.inspect(label: "next_move")

    [new_head | move(next_move, [rope_next | rest])]
  end

  defp next_direction(rope_head, rope_next) do
    differance =
      grid_difference(rope_head, rope_next)

    # |> IO.inspect(label: "differance")

    next_move(differance)
  end

  @next_move_by_delta %{
    # same y
    {0, 0} => {0, 0},
    {-1, 0} => {0, 0},
    {1, 0} => {0, 0},
    {-2, 0} => {-1, 0},
    {2, 0} => {1, 0},
    # +1 y
    {0, 1} => {0, 0},
    {-1, 1} => {0, 0},
    {1, 1} => {0, 0},
    {-2, 1} => {-1, 1},
    {2, 1} => {1, 1},
    # +2 y
    {0, 2} => {0, 1},
    {-1, 2} => {-1, 1},
    {1, 2} => {1, 1},
    {-2, 2} => {-1, 1},
    {2, 2} => {1, 1},
    # -1 y
    {0, -1} => {0, 0},
    {-1, -1} => {0, 0},
    {1, -1} => {0, 0},
    {-2, -1} => {-1, -1},
    {2, -1} => {1, -1},
    # -2 y
    {0, -2} => {0, -1},
    {-1, -2} => {-1, -1},
    {1, -2} => {1, -1},
    {-2, -2} => {-1, -1},
    {2, -2} => {1, -1}
  }
  defp next_move(difference), do: Map.get(@next_move_by_delta, difference)

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    pull_rope(input, 10)
  end

  defp fill_list(element, count) do
    Enum.map(1..count, fn _ -> element end)
  end

  defp parse_line(line) do
    [_, direction, distance] = Regex.run(~r/^([LRUD]) (\d+)$/, line)
    {translate_direction(direction), String.to_integer(distance)}
  end

  @move_matrix %{
    "U" => {0, 1},
    "D" => {0, -1},
    "L" => {-1, 0},
    "R" => {1, 0}
  }
  defp translate_direction(direction), do: Map.get(@move_matrix, direction)

  defp add_direction({dx, dy}, {x, y}), do: {x + dx, y + dy}

  defp grid_difference({x1, y1}, {x2, y2}), do: {x1 - x2, y1 - y2}
end
