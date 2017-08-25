defmodule QuizSite.Repo.Migrations.CreateResults do
  use Ecto.Migration

  def change do
    create table(:results) do
      add :quiz_name, :string

      timestamps()
    end

  end
end
