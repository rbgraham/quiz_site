defmodule QuizSite.Repo.Migrations.AddSiteAndOrderToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :sequence, :integer
      add :site, :string
    end
  end
end
