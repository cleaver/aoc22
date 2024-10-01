import AOC
import InputHelpers

aoc 2022, 1 do
  def p1(input) do
    process_input(input)
    |> Enum.max()
  end

  def p2(input) do
    process_input(input)
    |> Enum.sort(&(&1 >= &2))
    |> Enum.slice(0..2)
    |> Enum.sum()
  end

  defp process_input(input) do
    input
    |> parse_input(false)
    |> IO.inspect(label: "input")
    |> Enum.reduce([[]], fn calories, [current | history] ->
      case Integer.parse(calories) do
        {num_calories, _} ->
          [[num_calories | current] | history]

        :error ->
          [[], current | history]
      end
    end)
    |> Enum.map(fn calories_list ->
      Enum.sum(calories_list)
    end)
  end
end
