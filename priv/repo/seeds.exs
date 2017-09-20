# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     QuizSite.Repo.insert!(%QuizSite.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule QuizSite.DatabaseSeeder do
  alias QuizSite.Repo
  alias QuizSite.Page.Card
  alias QuizSite.Cards.Section
  alias QuizSite.Cards.Question
  alias QuizSite.Questions.Choice
  alias QuizSite.Sections.Condition

  def insert_card(card) do
    Card.changeset(%Card{}, card)
    |> Repo.insert!
  end

  def insert_content_card(card) do
    insert_card(card)
    |> insert_questions(card)
    |> insert_sections(card)
  end

  def insert_questions(card, %{ "questions" => questions }) do
    Enum.each(questions, &(QuizSite.Cards.add_question_or_section(card, &1)))
    card
  end

  def insert_questions(card, _) do
    card
  end

  def insert_sections(card, %{ "sections" => sections }) do
    Enum.each(sections, &(QuizSite.Cards.add_question_or_section(card, &1)))
    card
  end

  def insert_sections(card, _) do
    card
  end

  def insert_cards do
    case load_from_yaml() do
      %{ "cards" => cards } ->
        cards
        |> Enum.each(fn (card) -> insert_content_card(card) end)
      cards ->
        IO.puts "Failed to find cards in config.exs specified yaml file."
        IO.puts(inspect(cards))
    end
  end

  def clear do
    Repo.delete_all(Card)
    Repo.delete_all(Question)
    Repo.delete_all(Section)
    Repo.delete_all(Choice)
    Repo.delete_all(Condition)
  end

  def load_from_yaml do
    load_from_yaml(Application.get_env(:quiz_site, :yaml_data_file))
  end

  def load_from_yaml(filename) do
    File.cwd! 
    |> Path.join("priv/repo/#{filename}")
    |> YamlElixir.read_from_file
  end
end


QuizSite.DatabaseSeeder.clear
QuizSite.DatabaseSeeder.insert_cards
