defmodule MapSetAgent do
  def start(name \\ __MODULE__), do: Agent.start_link(fn -> %{} end, name: name)

  def stop(name \\ __MODULE__), do: Agent.stop(name)

  def set(value, name \\ __MODULE__) do
    Agent.update(name, fn state ->
      MapSet.put(state, value)
    end)
  end

  def member?(key, name \\ __MODULE__) do
    Agent.get(name, fn state ->
      MapSet.member?(state, key)
    end)
  end

  def size(name \\ __MODULE__) do
    Agent.get(name, fn state ->
      MapSet.size(state)
    end)
  end

  def dump(name \\ __MODULE__) do
    Agent.get(name, fn state ->
      state
    end)
  end
end
