import AOC

aoc 2022, 5 do
  @moduledoc """
  https://adventofcode.com/2022/day/5
  """

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    input
    |> String.split("\n")
    |> split_sections(:crate_mover_9000)
    |> organize_sections()
    |> process_commands()
    |> get_top_row()
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    input
    |> String.split("\n")
    |> split_sections(:crate_mover_9001)
    |> organize_sections()
    |> process_commands()
    |> IO.inspect(label: "Final Stack")
    |> get_top_row()
  end

  def split_sections(input, crane_model) do
    Enum.reduce(input, %{stack: [], moves: [], crane_model: crane_model}, fn line, acc ->
      case parse_line(line) do
        {:stack, row} ->
          %{acc | stack: [row | acc.stack]}

        {:moves, moves} ->
          %{acc | moves: acc.moves ++ [moves]}

        {:noop, _} ->
          acc

        {:error, line} ->
          IO.puts("Error parsing line: #{line}")
          acc
      end
    end)
  end

  defp parse_line(line) do
    cond do
      String.match?(line, ~r/^\s*$/) ->
        {:noop, nil}

      String.contains?(line, "[") ->
        {:stack, parse_stack(line)}

      String.starts_with?(line, "move") ->
        {:moves, parse_moves(line)}

      String.match?(line, ~r/^[\s\d]+$/) ->
        {:noop, nil}

      true ->
        {:error, line}
    end
  end

  defp parse_stack(line) do
    line
    |> split_crates()
  end

  defp split_crates(""), do: []

  defp split_crates(line) do
    {crate, rest} = String.split_at(line, 4)
    [parse_crate(crate) | split_crates(rest)]
  end

  defp parse_crate(crate) do
    case Regex.run(~r/\[(\w)\]/, crate) do
      nil -> nil
      [_, crate_letter] -> crate_letter
    end
  end

  defp parse_moves(line) do
    matching_moves = Regex.run(~r/move (\d+) from (\d+) to (\d+)/, line)
    tl(matching_moves)
  end

  defp organize_sections(%{stack: stack, moves: moves, crane_model: crane_model}) do
    %{
      crane_model: crane_model,
      stack: organize_stack(stack),
      moves: moves
    }
  end

  defp organize_stack(stack) do
    stack_width = length(hd(stack))

    blank_stack =
      for(
        col_num <- 1..stack_width,
        do: {Integer.to_string(col_num), []}
      )
      |> Enum.into(%{})

    Enum.reduce(stack, blank_stack, fn row, acc ->
      row
      |> Enum.with_index(1)
      |> Enum.reduce(acc, fn {crate, col_num}, acc ->
        maybe_stack_crate(acc, Integer.to_string(col_num), crate)
      end)
    end)
  end

  defp maybe_stack_crate(stacks, _col_num, nil), do: stacks

  defp maybe_stack_crate(stacks, col_num, crate) do
    Map.update!(stacks, col_num, &[crate | &1])
  end

  defp process_commands(%{stack: stack, moves: moves, crane_model: crane_model}) do
    Enum.reduce(moves, stack, fn [count, source, dest], stack ->
      move_crate(crane_model, stack, String.to_integer(count), source, dest)
    end)
  end

  defp move_crate(:crate_mover_9000, stack, 0, _source, _dest), do: stack

  defp move_crate(:crate_mover_9000, stack, count, source, dest) do
    {source_stack, source_crate} = pop_crate(stack, source)
    dest_stack = push_crate(source_stack, dest, source_crate)

    move_crate(:crate_mover_9000, dest_stack, count - 1, source, dest)
  end

  defp move_crate(:crate_mover_9001, stack, 0, _source, _dest), do: stack

  defp move_crate(:crate_mover_9001, stack, count, source, dest) do
    {updated_stack, source_crates} = pop_many_crates(stack, source, count)
    Map.update!(updated_stack, dest, &(source_crates ++ &1))
  end

  defp pop_many_crates(stack, source, count) do
    {popped_crates, remaining_crates} = Enum.split(stack[source], count)
    updated_stack = Map.put(stack, source, remaining_crates)
    {updated_stack, popped_crates}
  end

  defp pop_crate(stack, source) do
    popped_crate = hd(stack[source])
    updated_stack = Map.update!(stack, source, &tl/1)
    {updated_stack, popped_crate}
  end

  defp push_crate(stack, dest, crate) do
    Map.update!(stack, dest, &[crate | &1])
  end

  defp get_top_row(stack) do
    stack
    |> Enum.map(fn {_, crates} -> hd(crates) end)
    |> Enum.join()
  end
end
