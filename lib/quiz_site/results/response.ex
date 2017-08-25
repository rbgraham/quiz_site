defmodule QuizSite.Results.Response do
  use Ecto.Schema
  import Ecto.Changeset
  alias QuizSite.Results.Response


  schema "responses" do
    belongs_to :result, QuizSite.Questions.Result
    belongs_to :choice, QuizeSite.Questions.Choice

    timestamps()
  end

  @doc false
  def changeset(%Response{} = response, attrs) do
    response
    |> cast(attrs, [:choice_id, :result_id])
    |> validate_required([:choice_id, :result_id])
  end
end
