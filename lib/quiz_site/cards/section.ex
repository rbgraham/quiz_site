defmodule QuizSite.Cards.Section do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Cards.Section


  schema "sections" do
    field :content, :string
    field :cta, :string
    field :title, :string

    belongs_to :card, QuizSite.Page.Card
    has_many :conditions, QuizSite.Sections.Condition

    timestamps()
  end

  @doc false
  def changeset(%Section{} = section, attrs) do
    section
    |> cast(attrs, [:title, :content, :cta])
    |> validate_required([:title, :content])
  end
end
