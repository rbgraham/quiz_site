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
    %{ title: "Q3 | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 4},
    %{ title: "Q2 | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 3},
    %{ title: "Q1 | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 2},
    %{ title: "Thanks for taking the celebrity spending quiz", navigation: "", site: "celeb-quiz", sequence: 5},
    %{ title: "Take the celebrity spending quiz", navigation: "", site: "celeb-quiz", sequence: 1},
  ]

  @card_data %{ 
    5 => [%{ content: "Thanks for taking the quiz!", title: "Thank you." }],
    1 => [%{ content: "Learn which celebrity is your financial twin.", cta: "Find out who you are!", title: "The celebrity spending comparison quiz" }],
    2 => [%{ question: "Are you broke?", choices: [%{choice: "Def."}, %{choice: "No way."}] }],
    4 => [
      %{ question: "When I buy something I feel", choices: [ %{ choice: "Hot" }, %{ choice: "Bored" }, %{ choice: "Troubled" }]},
      %{ content: "This is a section of content", title: "This is a title for a section"},
      %{ content: "This is a second section", title: "2nd section title"}
      ],
    3 => [
      %{ question: "Do you save money for the future each month?", choices: [%{choice: "Yo. Word"}, %{choice: "Nah. New shoes beckon."}, %{choice: "Sometimes"}, %{choice: "What money?"}]}, 
      %{ content: "Answer as honestly as possible.", title: "Question tips" }
      ],
  }

  def insert_card(card) do
    Card.changeset(%Card{}, card)
    |> Repo.insert!
  end

  def insert_content_card(card, content) do
    card = insert_card(card)
    Enum.each(content, &(QuizSite.Cards.add_question_or_section(card, &1)))
  end

  def insert_cards do
    @card_list
    |> Enum.each(fn (card) -> insert_content_card(card, @card_data[card[:sequence]]) end)
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
