defmodule TaiShangNftParser.Users.UsersExtra do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftParser.Users.User
  alias TaiShangNftParser.Repo
  alias TaiShangNftParser.Users.UsersExtra, as: Ele

  schema "users_extra" do
    field :group, :string, default: "basic"
    belongs_to :user, User

    timestamps()
  end

  def create(attrs \\ %{}) do
    %Ele{}
    |> Ele.changeset(attrs)
    |> Repo.insert()
  end

  def change(%Ele{} = ele, attrs) do
    ele
    |> changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Ele{} = ele) do
    Ele.changeset(ele, %{})
  end

  @doc false
  def changeset(%Ele{} = ele, attrs) do
    ele
    |> cast(attrs, [:group, :user_id])
  end
end
