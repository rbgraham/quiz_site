defmodule QuizSite.Repo.Migrations.CreateChoiceOptionalCopy do
  use Ecto.Migration

  def change do
    alter table(:choices) do
      add :microcopy, :boolean, default: true
    end
  end
end
