defmodule QuizSite.Repo.Migrations.CreateConditions do
  use Ecto.Migration

  def change do
    create table(:conditions) do
      add :condition, :string
      add :section_id, :integer

      timestamps()
    end

  end
end
