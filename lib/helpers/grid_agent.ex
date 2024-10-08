defmodule GridAgent do
  def start(list, name),
    do: Agent.start_link(fn -> load(list) end, name: name)

  def start(),
    do: Agent.start_link(fn -> Arrays.new() end)

  def stop(name), do: Agent.stop(name)

  def load(list, name) do
    Agent.update(name, fn _state ->
      load(list)
    end)
  end

  defp load(list) do
    list
    |> Enum.map(&Arrays.new(&1))
    |> Arrays.new()
  end

  def set(row, col, value, name) do
    Agent.update(name, fn state ->
      new_row = state |> Arrays.get(row) |> Arrays.replace(col, value)
      state |> Arrays.replace(row, new_row)
    end)
  end

  def get(row, col, name) do
    Agent.get(name, fn state ->
      state
      |> Arrays.get(row)
      |> Arrays.get(col)
    end)
  end

  def row_count(name) do
    Agent.get(name, fn state ->
      state |> Arrays.size()
    end)
  end

  def col_count(name) do
    Agent.get(name, fn state ->
      state |> Arrays.get(0) |> Arrays.size()
    end)
  end

  def dump(name) do
    Agent.get(name, fn state ->
      Enum.map(state, &Arrays.to_list/1)
    end)
  end
end
