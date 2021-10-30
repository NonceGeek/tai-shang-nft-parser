defmodule TaiShangNftParser.Repo.Migrations.CreateUserExtra do
  use Ecto.Migration

  def change do
    create table(:users_extra) do
      add :group, :string, default: "basic"
      add :user_id, :integer
      timestamps()
    end
  end
end
