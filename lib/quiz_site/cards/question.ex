defmodule QuizSite.Cards.Question do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Cards.Question


  schema "questions" do
    field :question, :string
    field :subtext, :string
    field :preserve_order, :boolean

    belongs_to :card, QuizSite.Page.Card
    has_many :choices, QuizSite.Questions.Choice

    timestamps()
  end

  @doc false
  def changeset(%Question{} = question, attrs) do
    question
    |> cast(attrs, [:question, :subtext, :preserve_order])
    |> validate_required([:question])
  end
end
