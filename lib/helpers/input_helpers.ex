defmodule InputHelpers do
  def parse_input(input, trim \\ true) do
    input
    |> String.split("\n", trim: trim)
    |> Enum.map(&String.trim/1)
  end

  def find_substring_index(string, substring) do
    case :binary.match(string, substring) do
      {start, _length} -> start
      :nomatch -> nil
    end
  end

  def line_to_keyword(line) do
    [name, data] = String.split(line, ":")

    key = name |> to_snake_case() |> String.to_atom()
    {key, data}
  end

  def to_snake_case(string) do
    string
    |> String.downcase()
    |> String.replace(~r/[^\w\s\d]/, "")
    |> String.trim()
    |> String.replace(~r/\s+/, "_")
  end

  def parse_integer_list(string) do
    string
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
