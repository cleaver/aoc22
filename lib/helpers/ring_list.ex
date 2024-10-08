defmodule RingList do
  def init(list) when is_list(list), do: {[], list}

  def next({[], []}), do: {[], []}

  def next({visited, []}) do
    [a | remain] = Enum.reverse(visited)
    {[a], remain}
  end

  def next({visited, [a | remain]}), do: {[a] ++ visited, remain}

  def value({[], []}, _), do: nil
  def value({visited, []}), do: List.last(visited)
  def value({_, remain}), do: hd(remain)
end
