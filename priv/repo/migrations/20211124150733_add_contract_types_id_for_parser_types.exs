defmodule TaiShangNftParser.Repo.Migrations.AddContractTypesIdForParserTypes do
  use Ecto.Migration

  def change do
    alter table :parser_types do
      add :contract_types_id, :integer
    end
  end
end
