defmodule TaiShangNftParser.Repo.Migrations.CreateContracts do
  use Ecto.Migration

  def change do
    create table(:contracts) do
      add :name, :string
      add :description, :string

      add :code_url, :string
      add :contract_types_id, :integer
      timestamps()
    end
  create unique_index(:contracts, [:name])
  end
end
