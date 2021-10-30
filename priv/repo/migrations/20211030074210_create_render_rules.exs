defmodule TaiShangNftParser.Repo.Migrations.CreateParserRules do
  use Ecto.Migration

  def change do
    create table(:parser_rules) do
      add :unique_id, :integer
      add :description, :string
      add :object_to_resource, :map
      add :contract_types_id, :integer
      timestamps()
    end

  end
end
