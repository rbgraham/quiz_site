defmodule QuizSite.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :title, :string
      add :content, :text
      add :cta, :string

      timestamps()
    end

  end
end
