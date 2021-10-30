defmodule TaiShangNftParser.Contracts do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftParser.Repo
  alias TaiShangNftParser.ContractTypes
  alias TaiShangNftParser.Contracts, as: Ele

  schema "contracts" do
    field :name, :string
    field :description, :string
    field :code_url, :string

    belongs_to :contract_types, ContractTypes
    timestamps()
  end

  def get_all() do
    Ele
    |> Repo.all()
    |> Enum.map(&(preload(&1)))
  end

  def preload(ele) do
    Repo.preload(ele, :contract_types)
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
    |> cast(attrs, [:name, :description, :code_url, :contract_types_id])
  end
end
