defmodule QuizSite.CardsTest do
  use QuizSite.DataCase

  alias QuizSite.Cards

  describe "sections" do
    alias QuizSite.Cards.Section

    @valid_attrs %{content: "some content", cta: "some cta", title: "some title", image_width: "125px", email_form: false}
    @update_attrs %{content: "some updated content", cta: "some updated cta", title: "some updated title"}
    @invalid_attrs %{content: nil, cta: nil, title: nil}

    def section_fixture(attrs \\ %{}) do
      {:ok, section} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cards.create_section()

      section
    end

    test "list_sections/0 returns all sections" do
      section = section_fixture()
      assert Cards.list_sections() == [section]
    end

    test "get_section!/1 returns the section with given id" do
      section = section_fixture()
      assert Cards.get_section!(section.id) == section
    end

    test "create_section/1 with valid data creates a section" do
      assert {:ok, %Section{} = section} = Cards.create_section(@valid_attrs)
      assert section.content == "some content"
      assert section.cta == "some cta"
      assert section.title == "some title"
    end

    test "create_section/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_section(@invalid_attrs)
    end

    test "update_section/2 with valid data updates the section" do
      section = section_fixture()
      assert {:ok, section} = Cards.update_section(section, @update_attrs)
      assert %Section{} = section
      assert section.content == "some updated content"
      assert section.cta == "some updated cta"
      assert section.title == "some updated title"
    end

    test "update_section/2 with invalid data returns error changeset" do
      section = section_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_section(section, @invalid_attrs)
      assert section == Cards.get_section!(section.id)
    end

    test "delete_section/1 deletes the section" do
      section = section_fixture()
      assert {:ok, %Section{}} = Cards.delete_section(section)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_section!(section.id) end
    end

    test "change_section/1 returns a section changeset" do
      section = section_fixture()
      assert %Ecto.Changeset{} = Cards.change_section(section)
    end
  end

  describe "questions" do
    alias QuizSite.Cards.Question

    @valid_attrs %{question: "some question", subtext: "some subtext"}
    @update_attrs %{question: "some updated question", subtext: "some updated subtext"}
    @invalid_attrs %{question: nil, subtext: nil}

    def question_fixture(attrs \\ %{}) do
      {:ok, question} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cards.create_question()

      question
    end

    test "list_questions/0 returns all questions" do
      question = question_fixture()
      assert Cards.list_questions() == [question]
    end

    test "get_question!/1 returns the question with given id" do
      question = question_fixture()
      assert Cards.get_question!(question.id) == question
    end

    test "create_question/1 with valid data creates a question" do
      assert {:ok, %Question{} = question} = Cards.create_question(@valid_attrs)
      assert question.question == "some question"
      assert question.subtext == "some subtext"
    end

    test "create_question/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cards.create_question(@invalid_attrs)
    end

    test "update_question/2 with valid data updates the question" do
      question = question_fixture()
      assert {:ok, question} = Cards.update_question(question, @update_attrs)
      assert %Question{} = question
      assert question.question == "some updated question"
      assert question.subtext == "some updated subtext"
    end

    test "update_question/2 with invalid data returns error changeset" do
      question = question_fixture()
      assert {:error, %Ecto.Changeset{}} = Cards.update_question(question, @invalid_attrs)
      assert question == Cards.get_question!(question.id)
    end

    test "delete_question/1 deletes the question" do
      question = question_fixture()
      assert {:ok, %Question{}} = Cards.delete_question(question)
      assert_raise Ecto.NoResultsError, fn -> Cards.get_question!(question.id) end
    end

    test "change_question/1 returns a question changeset" do
      question = question_fixture()
      assert %Ecto.Changeset{} = Cards.change_question(question)
    end
  end
end
