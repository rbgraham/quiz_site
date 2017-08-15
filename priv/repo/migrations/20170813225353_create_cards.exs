defmodule QuizSite.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :navigation, :string
      add :title, :string

      timestamps()
    end

  end
end
