defmodule QuizSite.Repo.Migrations.CreateResponses do
  use Ecto.Migration

  def change do
    create table(:responses) do
      add :choice_id, :integer
      add :result_id, :integer

      timestamps()
    end

  end
end
