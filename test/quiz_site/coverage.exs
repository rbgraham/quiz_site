defmodule QuizSite.QuizCoverage do
  use QuizSite.DataCase

  describe "quiz coverage" do
    test "are all potential quiz outcomes covered by conditional results" do
      coverage_data = QuizSite.DataCase.load_from_yaml
      question_cards = collect_question_cards(coverage_data)
      conditional_cards = collect_conditional_cards(coverage_data)
      cond_arr = conditions_array(conditional_cards)
      
      all_perms = compute_permutations(choices_array(question_cards))
      IO.puts "Total perms: #{inspect(length(all_perms))}"
      IO.puts "Conditions sets: #{inspect(cond_arr)}"
      coverage = all_perms
      |> Enum.map(fn(x) -> case_covered?(x, cond_arr) end)
      
      covered = length(Enum.filter(coverage, fn(x) -> x == true end))
      IO.puts "#{inspect(covered)} of #{inspect(length(all_perms))} (#{inspect( covered/length(all_perms) )}) is covered."
    end
  end

  describe "permutation generation" do
    test "simple cases compute correctly" do
      assert compute_permutations([[1,2], [3,4], [5,6]]) == [{5, 3, 1}, {6, 3, 1}, {5, 4, 1}, {6, 4, 1}, {5, 3, 2}, {6, 3, 2}, {5, 4, 2}, {6, 4, 2}]
      assert compute_permutations([[1,2], [3,4,5,6]]) == [{3, 1}, {4, 1}, {5, 1}, {6, 1}, {3, 2}, {4, 2}, {5, 2}, {6, 2}]
      assert compute_permutations([[1], [2]]) == [{2,1}]
    end

    test "complex cases have the correct case counts" do
      assert length(compute_permutations([[1,2,3,4], [5,6], [7,8,9], [10,11,12]])) == compute_total_permutations([[1,2,3,4], [5,6], [7,8,9], [10,11,12]])
      assert length(compute_permutations([[1,2,3,4,5], [5,6,7], [7,8,9], [10,11,12], [1,2], [1,2,3], [1,2,3]])) == compute_total_permutations([[1,2,3,4,5], [5,6,7], [7,8,9], [10,11,12], [1,2], [1,2,3], [1,2,3]])
    end
  end

  def case_covered?(choices, conds) when is_tuple(choices) and is_list(conds) do
    case_covered?(Tuple.to_list(choices), conds)
  end

  def case_covered?(choices, [head_cond | tail]) when is_list(head_cond) do
    case tail do
    [] ->
      case_covered?(choices, head_cond)
    _ ->
      case_covered?(choices, head_cond) || case_covered?(choices, tail)
    end
  end

  def case_covered?(choices, conds) when is_list(conds) do
    conds
    |> Enum.map(fn(cond) -> Enum.member?(choices, cond) end)
    |> Enum.reduce(fn(acc, x) -> acc && x end)
  end

  def collect_question_cards(data) do
    data["cards"]
    |> Enum.filter(fn (c) -> Map.has_key?(c, "questions") end)
  end

  def collect_conditional_cards(data) do
    data["cards"]
    |> Enum.filter(fn (c) -> Map.has_key?(c, "sections") end)
    |> Enum.filter(fn (c) -> has_condition?(c) end)
  end

  def conditions_array(conditional_cards) do
    conditional_cards
    |> Enum.map(fn(c) -> Enum.map(c["sections"], fn(s) -> Enum.map(s["conditions"], fn(cond) -> cond["condition"] end) end) end)
    |> List.first
  end

  def has_condition?(card) do
    sections_has_condition?(card["sections"])
  end

  def sections_has_condition?(sections) do
    Enum.filter(sections, fn(s) -> section_has_condition?(s) end)
    |> length > 0
  end

  def section_has_condition?(section) do
    case section do
    %{"conditions" => _} -> 
      true
    _ -> 
      false
    end
  end

  def compute_total_permutations(choices) do
    choices
    |> Enum.map(fn(c) -> length(c) end)
    |> List.flatten
    |> Enum.reduce(fn(acc, x) -> acc * x end)
  end

  def choices_array(questions) do
    questions
    |> Enum.map(fn(c) -> List.first(Enum.map(c["questions"], fn(q) -> Enum.map(q["choices"], fn(ch) -> ch["choice"] end) end)) end)
  end

  def compute_permutations([[h | t] | tail]) do
    case t do
      [] -> permute([h], tail)
      _ -> permute([h], tail) ++ compute_permutations([t | tail])
    end
  end

  def permute(fixed, [[h | tail] | []]) do
    case tail do
    [h2 | []] ->
      [ List.to_tuple([h | fixed]), List.to_tuple([h2 | fixed])]
    [] ->
      [List.to_tuple([h | fixed])]
    _ ->
      [List.to_tuple([h | fixed]) | permute(fixed, [tail])]
    end
  end

  def permute(fixed, [[h | t] | tail]) do
    case t do
      [] -> permute([h | fixed], tail)
      _ -> permute([h | fixed], tail) ++ permute(fixed, [t | tail])
    end
  end
end
