import AOC

aoc 2022, 2 do
  @moduledoc """
  https://adventofcode.com/2022/day/2
  """
  import InputHelpers

  @game_results %{
    :rock => %{
      :rock => :draw,
      :paper => :lose,
      :scissors => :win
    },
    :paper => %{
      :rock => :win,
      :paper => :draw,
      :scissors => :lose
    },
    :scissors => %{
      :rock => :lose,
      :paper => :win,
      :scissors => :draw
    }
  }

  @move_score %{
    :rock => 1,
    :paper => 2,
    :scissors => 3
  }

  @doc """
      iex> p1(example_string())
  """
  def p1(input) do
    input
    |> parse_input()
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce(0, fn [p1_move, p2_move], acc ->
      IO.puts(
        "Opp: #{p1_move} Me: #{p2_move} Score: #{calculate_score(opponent_move(p1_move), strategy_1(p2_move))}"
      )

      calculate_score(opponent_move(p1_move), strategy_1(p2_move)) + acc
    end)
  end

  defp strategy_1("X"), do: :rock
  defp strategy_1("Y"), do: :paper
  defp strategy_1("Z"), do: :scissors

  @doc """
      iex> p2(example_string())
  """
  def p2(input) do
    input
    |> parse_input()
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.reduce(0, fn [p1_move, p2_move], acc ->
      calculate_score(opponent_move(p1_move), strategy_2(p1_move, p2_move)) + acc
    end)
  end

  # X = lose, Y = draw, Z = win
  defp strategy_2("A", "X"), do: :scissors
  defp strategy_2("A", "Y"), do: :rock
  defp strategy_2("A", "Z"), do: :paper
  defp strategy_2("B", "X"), do: :rock
  defp strategy_2("B", "Y"), do: :paper
  defp strategy_2("B", "Z"), do: :scissors
  defp strategy_2("C", "X"), do: :paper
  defp strategy_2("C", "Y"), do: :scissors
  defp strategy_2("C", "Z"), do: :rock

  def opponent_move("A"), do: :rock
  def opponent_move("B"), do: :paper
  def opponent_move("C"), do: :scissors

  def calculate_score(player1, player2) do
    case @game_results[player2][player1] do
      :win -> 6
      :lose -> 0
      :draw -> 3
    end
    |> Kernel.+(@move_score[player2])
  end
end
