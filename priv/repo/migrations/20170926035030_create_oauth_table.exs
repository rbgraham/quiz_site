defmodule QuizSite.Repo.Migrations.CreateOauthTable do
  use Ecto.Migration

  def change do
    create table(:oauths) do
      add :app, :string
      add :token, :string
      add :expiration, :date

      timestamps()
    end
  end
end
