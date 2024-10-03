import AOC

aoc_test 2022, 4, async: true do
  describe "count_subset/1" do
    test "gives 1 for valid subset" do
      assert count_subset([[1, 4], [1, 2]]) == 1
      assert count_subset([[1, 2], [1, 4]]) == 1

      assert count_subset([[1, 5], [3, 5]]) == 1
      assert count_subset([[3, 5], [1, 5]]) == 1

      assert count_subset([[1, 5], [2, 4]]) == 1
      assert count_subset([[2, 4], [1, 5]]) == 1

      assert count_subset([[1, 2], [1, 2]]) == 1
    end

    test "gives 0 for non-subset" do
      assert count_subset([[1, 2], [3, 4]]) == 0
      assert count_subset([[3, 4], [1, 2]]) == 0

      assert count_subset([[1, 2], [2, 4]]) == 0
      assert count_subset([[2, 4], [1, 2]]) == 0

      assert count_subset([[1, 3], [2, 4]]) == 0
      assert count_subset([[2, 4], [1, 3]]) == 0
    end
  end

  describe "count_overlap/1" do
    test "gives 1 for valid overlap" do
      assert count_overlap([[1, 4], [1, 2]]) == 1
      assert count_overlap([[1, 2], [1, 4]]) == 1

      assert count_overlap([[1, 5], [3, 5]]) == 1
      assert count_overlap([[3, 5], [1, 5]]) == 1

      assert count_overlap([[1, 5], [2, 4]]) == 1
      assert count_overlap([[2, 4], [1, 5]]) == 1

      assert count_overlap([[1, 5], [4, 6]]) == 1
      assert count_overlap([[4, 6], [1, 5]]) == 1

      assert count_overlap([[1, 5], [5, 6]]) == 1
      assert count_overlap([[5, 6], [1, 5]]) == 1

      assert count_overlap([[1, 2], [1, 2]]) == 1
    end

    test "gives 0 for non-overlap" do
      assert count_overlap([[1, 2], [3, 4]]) == 0
      assert count_overlap([[3, 4], [1, 2]]) == 0
    end
  end
end
