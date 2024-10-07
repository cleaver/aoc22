import AOC

aoc 2022, 7 do
  @moduledoc """
  https://adventofcode.com/2022/day/7
  """

  import InputHelpers

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    commands =
      input
      |> parse_input()
      |> build_command_list([])
      |> Enum.reverse()

    directory_tree = process_commands(commands)
    size_tree = build_size_tree(directory_tree["/"])

    size_tree
    |> find_smaller()

    # |> Enum.sum()
  end

  defp build_command_list([], commands), do: commands

  defp build_command_list([command | rest], processed_commands) do
    if String.starts_with?(command, "$") do
      build_command_list(rest, [{command, []} | processed_commands])
    else
      build_command_list(rest, append_command_output(command, processed_commands))
    end
  end

  defp process_commands(commands) do
    {_path, tree} =
      Enum.reduce(commands, {["/"], %{"/" => []}}, fn {command, output}, acc ->
        case String.slice(command, 0..3) do
          "$ ls" -> do_ls(acc, output)
          "$ cd" -> do_cd(acc, command)
        end
      end)

    tree
  end

  defp do_ls({path, tree}, listing) do
    new_tree = put_in(tree, path, parse_ls(listing))
    {path, new_tree}
  end

  defp parse_ls(listing) do
    listing
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn [details, name] ->
      if details == "dir" do
        {name, %{}}
      else
        {name, String.to_integer(details)}
      end
    end)
    |> Enum.into(%{})
  end

  defp do_cd({path, tree}, command) do
    dir_name = String.slice(command, 5..-1//1)
    new_path = change_path(path, dir_name)
    new_tree = add_dir(tree, new_path)
    {new_path, new_tree}
  end

  defp change_path(path, "..") do
    {_, new_path} = List.pop_at(path, -1)
    new_path
  end

  defp change_path(_path, "/"), do: ["/"]

  defp change_path(path, dir_name) do
    path ++ [dir_name]
  end

  # defp add_dir(tree, []), do: tree

  defp add_dir(tree, path) do
    if get_in(tree, path) do
      tree
    else
      put_in(tree, path, %{})
    end
  end

  defp append_command_output(new_output, [{command, output} | rest]) do
    [{command, output ++ [new_output]} | rest]
  end

  defp build_size_tree(tree) do
    Enum.reduce(tree, %{}, fn {name, contents}, acc ->
      size = Map.get(acc, :size, 0)

      if is_integer(contents) do
        Map.put(acc, :size, size + contents)
      else
        new_contents = build_size_tree(contents)

        acc
        |> Map.put(name, new_contents)
        |> Map.put(:size, size + new_contents[:size])
      end
    end)
  end

  defp find_smaller(tree) do
    Enum.reduce(tree, [], fn {name, contents}, acc ->
      if name == :size do
        if contents < 100_000_000, do: [contents | acc], else: acc
      else
        find_smaller(contents) ++ acc
      end
    end)
  end

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    commands =
      input
      |> parse_input()
      |> build_command_list([])
      |> Enum.reverse()

    directory_tree = process_commands(commands)
    size_tree = build_size_tree(directory_tree["/"])
    total_space = 70_000_000
    used_space = size_tree[:size]
    free_space = total_space - used_space
    required_free_space = 30_000_000
    additional_needed_space = required_free_space - free_space
    IO.inspect(additional_needed_space, label: "Additional Needed Space")

    IO.inspect(free_space, label: "Free Space")

    size_tree
    |> find_sizes()
    |> Enum.filter(&(&1 > additional_needed_space))
    |> Enum.min()
  end

  defp find_sizes(tree) do
    Enum.reduce(tree, [], fn {name, contents}, acc ->
      if name == :size do
        [contents | acc]
      else
        find_smaller(contents) ++ acc
      end
    end)
  end
end
