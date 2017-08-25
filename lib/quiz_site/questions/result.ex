defmodule QuizSite.Questions.Result do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Questions.Result


  schema "results" do
    field :quiz_name, :string
    field :completed, :boolean

    has_many :responses, QuizSite.Results.Response

    timestamps()
  end

  @doc false
  def changeset(%Result{} = result, attrs) do
    result
    |> cast(attrs, [:quiz_name, :completed])
    |> validate_required([:quiz_name])
  end
end
