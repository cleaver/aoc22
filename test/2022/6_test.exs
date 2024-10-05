import AOC

aoc_test 2022, 6, async: true do
  describe "p1/1" do
    test "example" do
      assert p1("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
      assert p1("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
      assert p1("nppdvjthqldpwncqszvftbrmjlhg") == 6
      assert p1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
      assert p1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11
    end
  end

  describe "p2/1" do
    test "example" do
      assert p2("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 19
      assert p2("bvwbjplbgvbhsrlpgdmjqwftvncz") == 23
      assert p2("nppdvjthqldpwncqszvftbrmjlhg") == 23
      assert p2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 29
      assert p2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 26
    end
  end
end
