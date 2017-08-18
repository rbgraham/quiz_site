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

  @card_list [
    %{ title: "How would you say you spend? | Celebrity Spending", class: Question, navigation: "", site: "celeb-quiz", sequence: 2},
    %{ title: "Thanks for taking the celebrity spending quiz", class: Section, navigation: "", site: "celeb-quiz", sequence: 3},
    %{ title: "Take the celebrity spending quiz", class: Section, navigation: "", site: "celeb-quiz", sequence: 1},
  ]

  @card_data %{ 
    3 => %{ content: "Thanks for taking the quiz!", cta: "Take another quiz!", title: "Thank you." },
    1 => %{ content: "Learn which celebrity is your financial twin.", cta: "Find out who you are!", title: "The celebrity spending comparison quiz" },
    2 =>  %{ question: "Are you broke?", subtext: "It can happen to the best of us.", choices: [%{choice: "Def."}, %{choice: "No way."}] },
  }

  def insert_card(card) do
    Card.changeset(%Card{}, card)
    |> Repo.insert!
  end

  def insert_content_card(card, content, klass) do
    insert_card(card)
    |> QuizSite.Cards.add_question_or_section(klass, content)
  end

  def insert_cards do
    @card_list
    |> Enum.each(fn (card) -> insert_content_card(card, @card_data[card[:sequence]], card[:class]) end)
  end

  def clear do
    Repo.delete_all(Card)
    Repo.delete_all(Question)
    Repo.delete_all(Section)
    Repo.delete_all(Choice)
  end
end

QuizSite.DatabaseSeeder.clear
QuizSite.DatabaseSeeder.insert_cards
