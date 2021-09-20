defmodule TaiShangNftParser.Repo.Migrations.CreateParserTypes do
  use Ecto.Migration

  def change do
    create table :parser_types do
      add :name, :string
      add :unique_id, :integer
      add :resources, :map
      timestamps()
    end

    create unique_index(:parser_types, [:unique_id])
  end
end
