defmodule TaiShangNftParser.ContractTypes do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftParser.Repo
  alias TaiShangNftParser.ContractTypes, as: Ele

  schema "contract_types" do
    field :name, :string
    field :description, :string
    field :handler, :string
    timestamps()
  end

  def get_all() do
    Repo.all(Ele)
  end

  def get_by_name(name) do
    Repo.get_by(Ele, name: name)
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
    |> cast(attrs, [:name, :description, :handler])
  end
end
