defmodule QuizSite.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :question, :string
      add :subtext, :text

      timestamps()
    end

  end
end
