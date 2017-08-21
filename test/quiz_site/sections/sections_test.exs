defmodule QuizSite.SectionsTest do
  use QuizSite.DataCase

  alias QuizSite.Sections

  describe "conditions" do
    alias QuizSite.Sections.Condition

    @valid_attrs %{condition: "some condition", question_id: 42}
    @update_attrs %{condition: "some updated condition", question_id: 43}
    @invalid_attrs %{condition: nil, question_id: nil}

    def condition_fixture(attrs \\ %{}) do
      {:ok, condition} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Sections.create_condition()

      condition
    end

    test "list_conditions/0 returns all conditions" do
      condition = condition_fixture()
      assert Sections.list_conditions() == [condition]
    end

    test "get_condition!/1 returns the condition with given id" do
      condition = condition_fixture()
      assert Sections.get_condition!(condition.id) == condition
    end

    test "create_condition/1 with valid data creates a condition" do
      assert {:ok, %Condition{} = condition} = Sections.create_condition(@valid_attrs)
      assert condition.condition == "some condition"
      assert condition.question_id == 42
    end

    test "create_condition/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sections.create_condition(@invalid_attrs)
    end

    test "update_condition/2 with valid data updates the condition" do
      condition = condition_fixture()
      assert {:ok, condition} = Sections.update_condition(condition, @update_attrs)
      assert %Condition{} = condition
      assert condition.condition == "some updated condition"
      assert condition.question_id == 43
    end

    test "update_condition/2 with invalid data returns error changeset" do
      condition = condition_fixture()
      assert {:error, %Ecto.Changeset{}} = Sections.update_condition(condition, @invalid_attrs)
      assert condition == Sections.get_condition!(condition.id)
    end

    test "delete_condition/1 deletes the condition" do
      condition = condition_fixture()
      assert {:ok, %Condition{}} = Sections.delete_condition(condition)
      assert_raise Ecto.NoResultsError, fn -> Sections.get_condition!(condition.id) end
    end

    test "change_condition/1 returns a condition changeset" do
      condition = condition_fixture()
      assert %Ecto.Changeset{} = Sections.change_condition(condition)
    end
  end
end
