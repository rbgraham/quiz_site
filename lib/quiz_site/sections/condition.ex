defmodule QuizSite.Sections.Condition do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Sections.Condition


  schema "conditions" do
    field :condition, :string
    belongs_to :section, QuizSite.Cards.Section
    timestamps()
  end

  @doc false
  def changeset(%Condition{} = condition, attrs) do
    condition
    |> cast(attrs, [:condition, :section_id])
    |> validate_required([:condition, :section_id])
  end
end
