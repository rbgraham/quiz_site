defmodule QuizSite.Page.Card do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Page.Card


  schema "cards" do
    field :navigation, :string
    field :title, :string
    field :sequence, :integer
    field :site, :string

    has_many :questions, QuizSite.Cards.Question
    has_many :sections, QuizSite.Cards.Section

    timestamps()
  end

  @doc false
  def changeset(%Card{} = card, attrs) do
    card
    |> cast(attrs, [:navigation, :title, :sequence, :site])
    |> validate_required([:title, :sequence, :site])
  end
end
