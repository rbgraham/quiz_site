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
    %{ title: "Saving | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 2},
    %{ title: "Eating out | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 3},
    %{ title: "Day job | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 4},
    %{ title: "Investing | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 5},
    %{ title: "Shopping | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 6},
    %{ title: "Retirement | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 7},
    %{ title: "Income level | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 8},
    %{ title: "Age | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 9},
    %{ title: "Credit | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 10},
    %{ title: "Budgeting | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 11},
    %{ title: "Car | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 12},
    %{ title: "Debts | Celebrity Spending", navigation: "", site: "celeb-quiz", sequence: 13},
    %{ title: "Thanks for taking the celebrity spending quiz", navigation: "", site: "celeb-quiz", sequence: 14},
    %{ title: "Take the celebrity spending quiz", navigation: "", site: "celeb-quiz", sequence: 1},
  ]

  @card_data %{ 
    1 => [%{ content: "Most people aren't Warren Buffet, but tell me you aren't Mike Tyson.", cta: "Find out now!", title: "Do you spend like Matt Damon or MC Hammer?", image_path: "money.png" }],
    2 => [%{ question: "How would you rate your saving habits?", choices: [%{choice: "Good.", image_path: "thumbsup.png" }, %{choice: "Bad", image_path: "crying.png"}] }],
    3 => [
      %{ question: "How often do you eat out?", choices: [%{choice: "Daily"}, %{choice: "Weekly"}, %{choice: "Monthly"}, %{choice: "Annually"}]}, 
      ],
    4 => [
      %{ question: "Do you earn money from a side hustle?", 
         choices: [ 
          %{ choice: "More than one", image_path: "strong.png" },
          %{ choice: "Yes", image_path: "target.png" },
          %{ choice: "No", image_path: "thumbsdown.png" },
          %{ choice: "What is a side hustle?"}]}
        ],
    5 => [
      %{ question: "What is your experience level with investing?",
         choices: [ %{ choice: "Ask me for advice.", image_path: "shades.png" },
         %{ choice: "Enough", image_path: "money.png" },
         %{ choice: "Found an advisor", image_path: "confused.png" },
         %{ choice: "Lost", image_path: "poo.png" }
        ]},
      ],
    6 => [
      %{ question: "How do you feel about shopping?", 
         choices: [ %{ choice: "Hot", image_path: "heart.png" },
         %{ choice: "Bored", image_path: "rock-on.png" },
         %{ choice: "Troubled", image_path: "crying.png" } 
      ]},
      ],
    7 => [
      %{ question: "When do you expect to retire?", 
         choices: [ %{ choice: "35" },
         %{ choice: "50" },
         %{ choice: "60" },
         %{ choice: "65"},
         %{ choice: "No plan"}]},
      ],
    8 => [
      %{ question: "What is your current income level?", 
         choices: [ %{ choice: "20k", image_path: "pray.png" },
         %{ choice: "30k", image_path: "poo.png" },
         %{ choice: "50k", image_path: "taco.png" },
         %{ choice: "75k", image_path: "strong.png"},
         %{ choice: "100k+", image_path: "money.png"}]},
      ],
    9 => [
      %{ question: "What is your age?", 
         choices: [ %{ choice: "20" },
         %{ choice: "30" },
         %{ choice: "40" },
         %{ choice: "50" },
         %{ choice: "60+"} ]},
      ],
    10 => [
      %{ question: "How many credit cards do you use?", 
         choices: [ %{ choice: "All of them?", image_path: "heart.png" },
         %{ choice: "None", image_path: "thumbsdown.png" },
         %{ choice: "A couple.", image_path: "two.png" }]},
      ],
    11 => [
      %{ question: "Do you actively budget?", 
         choices: [ %{ choice: "Actively what?", image_path: "clap.png" },
         %{ choice: "100%", image_path: "confused.png" },
         %{ choice: "Sometimes", image_path: "dead.png" }]},
      ],
    12 => [
      %{ question: "Do you have a car payment?", 
         choices: [ %{ choice: "More than one", image_path: "heart.png" },
         %{ choice: "Nope", image_path: "thumbsdown.png" },
         %{ choice: "Yes", image_path: "thumbsup.png" }]},
      ],
    13 => [
      %{ question: "Do you have debts besides a car and a home?", 
         choices: [ %{ choice: "Yes.", image_path: "two.png" },
         %{ choice: "No.", image_path: "clap.png" },
         %{ choice: "Only student loans.", image_path: "school.png" }]},
      ],      
    14 => [
      %{ content: "Thanks for taking the quiz!", title: "Thank you." },
      %{ content: "You're Jeremy Renner. Not bad, friend.", title: "Renner", conditions: [ %{ condition: "Yo. Word" } ]},
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
