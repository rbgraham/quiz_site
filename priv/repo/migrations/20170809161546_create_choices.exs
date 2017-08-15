defmodule QuizSite.Repo.Migrations.CreateChoices do
  use Ecto.Migration

  def change do
    create table(:choices) do
      add :choice, :string

      timestamps()
    end

  end
end
