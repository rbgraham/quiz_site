defmodule QuizSite.Repo.Migrations.AddCustomShareTextOpts do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :share, :boolean, default: false
      add :share_text, :string, default: nil
    end
  end
end
