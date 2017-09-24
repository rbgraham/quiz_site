defmodule QuizSite.Repo.Migrations.AddImageWidthToSection do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :image_width, :string, default: "125px"
    end
  end
end
