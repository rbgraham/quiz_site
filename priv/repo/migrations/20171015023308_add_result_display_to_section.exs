defmodule QuizSite.Repo.Migrations.AddResultDisplayToSection do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :result_display, :boolean, default: false
    end
  end
end
