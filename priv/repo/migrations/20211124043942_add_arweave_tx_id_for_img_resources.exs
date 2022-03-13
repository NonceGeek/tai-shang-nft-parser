defmodule TaiShangNftParser.Repo.Migrations.AddArweaveTxIdForResources do
  use Ecto.Migration

  def change do
    alter table :resources do
      add :arweave_tx_id, :string
    end
  end
end
