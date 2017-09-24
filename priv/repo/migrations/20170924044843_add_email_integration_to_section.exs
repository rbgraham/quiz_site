defmodule QuizSite.Repo.Migrations.AddEmailIntegrationToSection do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :email_form, :boolean, default: false
    end
  end
end
