defmodule PriorityQueue do
  @moduledoc """
  From Jose's 2021 AoC

  https://github.com/josevalim/livebooks/blob/main/advent_of_code/2021/day-15.livemd
  """

  def new() do
    []
  end

  def add([{cur_weight, _} | _] = list, value, weight)
      when weight <= cur_weight,
      do: [{weight, value} | list]

  def add([head | tail], value, weight),
    do: [head | add(tail, value, weight)]

  def add([], value, weight),
    do: [{weight, value}]
end
