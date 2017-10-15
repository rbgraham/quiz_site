defmodule QuizSite.Repo.Migrations.AddSkipAndOrderToSection do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :skip_button, :boolean, default: false
    end

    alter table(:questions) do
      add :preserve_order, :boolean, default: false
    end
  end
end
