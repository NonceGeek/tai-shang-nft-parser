defmodule TaiShangNftParser.Repo.Migrations.AddArweaveTxIdForImgResources do
  use Ecto.Migration

  def change do
    alter table :img_resources do
      add :arweave_tx_id, :string
    end
  end
end
