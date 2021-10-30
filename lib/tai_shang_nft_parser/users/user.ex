defmodule TaiShangNftParser.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  alias TaiShangNftParser.Repo
  alias TaiShangNftParser.Users.User, as: Ele
  alias TaiShangNftParser.Users.UsersExtra

  schema "users" do
    pow_user_fields()
    has_one :user_extra, UsersExtra
    timestamps()
  end

  def get_all() do
    Ele
    |> Repo.all()
    |> Enum.map(&(preload(&1)))
  end

  def preload(ele) do
    Repo.preload(ele, :user_extra)
  end

  def create(email, passwd, group \\ "basic") do
    {:ok, %{id: id} = result} =
      %Ele{}
      |> changeset(
        %{
          email: email,
          password: passwd,
          password_confirmation: passwd
        })
      |> Repo.insert()
    {:ok, _} = UsersExtra.create(%{user_id: id, group: group})

    {:ok, preload(result)}
  end

  def get_by_id(id) do
    Ele
    |> Repo.get_by(id: id)
    |> preload()
  end

  def change(user, group_id) do
    user
    |> changeset(%{group_id: group_id})
    |> Repo.update()
  end
end
