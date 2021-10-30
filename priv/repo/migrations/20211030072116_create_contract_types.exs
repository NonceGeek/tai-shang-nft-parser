defmodule TaiShangNftParser.Repo.Migrations.CreateContractTypes do
  use Ecto.Migration

  def change do
    create table(:contract_types) do
      add :name, :string
      add :description, :string
      add :handler, :string
      timestamps()
    end
  end
end
