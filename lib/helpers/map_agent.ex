defmodule MapAgent do
  def start(name \\ __MODULE__), do: Agent.start_link(fn -> %{} end, name: name)

  def stop(name \\ __MODULE__), do: Agent.stop(name)

  def set(key, value, name \\ __MODULE__) do
    Agent.update(name, fn state ->
      Map.put(state, key, value)
    end)
  end

  def get(key, name \\ __MODULE__) do
    Agent.get(name, fn state ->
      Map.get(state, key)
    end)
  end

  def dump(name \\ __MODULE__) do
    Agent.get(name, fn state ->
      state
    end)
  end
end
