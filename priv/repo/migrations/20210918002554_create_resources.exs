defmodule TaiShangNftParser.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table :resources do
      add :name, :string
      add :unique_id, :integer
      add :description, :string
      add :source, :string
      add :uri, :text
      add :type, :string, default: "img"
      timestamps()
    end

    create unique_index(:resources, :unique_id)
    create unique_index(:resources, :name)
  end
end
