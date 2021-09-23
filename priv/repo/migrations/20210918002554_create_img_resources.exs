defmodule TaiShangNftParser.Repo.Migrations.CreateImgResources do
  use Ecto.Migration

  def change do
    create table :img_resources do
      add :name, :string
      add :unique_id, :integer
      add :description, :string
      add :img_source, :text
      timestamps()
    end

    create unique_index(:img_resources, :unique_id)
    create unique_index(:img_resources, :name)
  end
end
