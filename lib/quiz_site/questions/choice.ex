defmodule QuizSite.Questions.Choice do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Questions.Choice


  schema "choices" do
    field :choice, :string

    belongs_to :question, QuizSite.Card.Question

    timestamps()
  end

  @doc false
  def changeset(%Choice{} = choice, attrs) do
    choice
    |> cast(attrs, [:choice])
    |> validate_required([:choice])
  end
end
