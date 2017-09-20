defmodule QuizSite.Repo.Migrations.AddScoreToChoice do
  use Ecto.Migration

  def change do
    alter table(:choices) do
      add :score, :integer, default: 0
    end
  end
end
