defmodule QuizSite.Repo.Migrations.AddGtLtToCondition do
  use Ecto.Migration

  def change do
    alter table(:conditions) do
      add :greater_than, :integer, default: nil
      add :less_than, :integer, default: nil
      add :equal_to, :integer, default: nil
    end
  end
end
