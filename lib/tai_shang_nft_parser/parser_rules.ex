defmodule TaiShangNftParser.ParserRules do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftParser.Repo
  alias TaiShangNftParser.ContractTypes
  alias TaiShangNftParser.ParserRules, as: Ele

  schema "parser_rules" do
    field :unique_id, :integer
    field :description, :string
    field :object_to_resource, :map
    belongs_to :contract_types, ContractTypes
    timestamps()
  end

  def get_all() do
    Ele
    |> Repo.all()
    |> Enum.map(&(preload(&1)))
  end

  def get_by_unique_id(ele, id) do
    Repo.get_by(ele, unique_id: id)
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
    |> cast(attrs, [:unique_id, :description, :object_to_resource, :contract_types_id])
  end
end
