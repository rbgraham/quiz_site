defmodule QuizSite.QuestionsTest do
  use QuizSite.DataCase

  alias QuizSite.Questions

  describe "choices" do
    alias QuizSite.Questions.Choice

    @valid_attrs %{choice: "some choice"}
    @update_attrs %{choice: "some updated choice"}
    @invalid_attrs %{choice: nil}

    def choice_fixture(attrs \\ %{}) do
      {:ok, choice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Questions.create_choice()

      choice
    end

    test "list_choices/0 returns all choices" do
      choice = choice_fixture()
      assert Questions.list_choices() == [choice]
    end

    test "get_choice!/1 returns the choice with given id" do
      choice = choice_fixture()
      assert Questions.get_choice!(choice.id) == choice
    end

    test "create_choice/1 with valid data creates a choice" do
      assert {:ok, %Choice{} = choice} = Questions.create_choice(@valid_attrs)
      assert choice.choice == "some choice"
    end

    test "create_choice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Questions.create_choice(@invalid_attrs)
    end

    test "update_choice/2 with valid data updates the choice" do
      choice = choice_fixture()
      assert {:ok, choice} = Questions.update_choice(choice, @update_attrs)
      assert %Choice{} = choice
      assert choice.choice == "some updated choice"
    end

    test "update_choice/2 with invalid data returns error changeset" do
      choice = choice_fixture()
      assert {:error, %Ecto.Changeset{}} = Questions.update_choice(choice, @invalid_attrs)
      assert choice == Questions.get_choice!(choice.id)
    end

    test "delete_choice/1 deletes the choice" do
      choice = choice_fixture()
      assert {:ok, %Choice{}} = Questions.delete_choice(choice)
      assert_raise Ecto.NoResultsError, fn -> Questions.get_choice!(choice.id) end
    end

    test "change_choice/1 returns a choice changeset" do
      choice = choice_fixture()
      assert %Ecto.Changeset{} = Questions.change_choice(choice)
    end
  end
end
