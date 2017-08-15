defmodule QuizSite.Repo.Migrations.AddImagePaths do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add :image_path,  :string
    end

    alter table(:choices) do
      add :image_path, :string
    end
  end
end
