defmodule QuizSite.Repo.Migrations.AddCardIds do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :card_id, :integer
    end

    alter table(:questions) do
      add :section_id, :integer
      add :card_id, :integer
    end

    alter table(:choices) do
      add :question_id, :integer
    end
  end
end
