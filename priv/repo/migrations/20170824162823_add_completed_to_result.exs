defmodule QuizSite.Repo.Migrations.AddCompletedToResult do
  use Ecto.Migration

  def change do
    alter table(:results) do
      add :completed, :boolean, default: false
    end
  end
end
