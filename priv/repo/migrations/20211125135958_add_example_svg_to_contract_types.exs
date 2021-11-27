defmodule TaiShangNftParser.Repo.Migrations.AddExampleSvgToContractTypes do
  use Ecto.Migration

  def change do
    alter table :contract_types do
      add :example_svg, :text
    end
  end
end
