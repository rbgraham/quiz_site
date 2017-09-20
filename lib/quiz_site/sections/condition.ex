defmodule QuizSite.Sections.Condition do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Sections.Condition


  schema "conditions" do
    field :condition, :string
    field :equal_to, :integer
    field :greater_than, :integer
    field :less_than, :integer
    belongs_to :section, QuizSite.Cards.Section
    timestamps()
  end

  @doc false
  def changeset(%Condition{} = condition, attrs) do
    condition
    |> cast(attrs, [:condition, :section_id, :equal_to, :greater_than, :less_than])
    |> validate_required([:section_id])
  end
end
