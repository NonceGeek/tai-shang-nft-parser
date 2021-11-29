defmodule TaiShangNftParser.ParserTypes do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftParser.Repo
  alias TaiShangNftParser.ParserTypes,as: Ele
  alias TaiShangNftParser.ContractTypes
  alias Utils.RandGen


  schema "parser_types" do
    field :name, :string
    field :unique_id, :string # 16 bytes hex
    field :resources, :map
    belongs_to :contract_types, ContractTypes
    timestamps()
  end

  def generate(parser_name, resources, contract_type_name) do
   %{id: id} =
    ContractTypes.get_by_name(contract_type_name)
    unique_id = generate_unique_id()
    create(%{
      name: parser_name,
      unique_id: unique_id,
      resources: resources,
      contract_types_id: id
    })
  end

  def get_all() do
    Ele
    |> Repo.all()
    |> Enum.map(&(preload(&1)))
    |> Enum.map(&(handle_resources(&1)))
  end

  def preload(ele) do
    Repo.preload(ele, :contract_types)
  end

  def generate_unique_id(), do: RandGen.gen_hex(16)

  def get_by_id(nil), do: nil
  def get_by_id(ele) do
    Ele
    |> Repo.get_by(id: ele)
    |> preload()
    |> handle_resources()
  end

  def get_by_unique_id(nil), do: nil
  def get_by_unique_id(ele) do
    Ele
    |> Repo.get_by(unique_id: ele)
    |> handle_resources()
  end

  def get_by_name(nil), do: nil
  def get_by_name(ele) do
    Ele
    |> Repo.get_by(name: ele)
    |> handle_resources()
  end

  def handle_resources(nil), do: nil
  def handle_resources(%{resources: resources} = ele) do
    %{ele | resources: ExStructTranslator.to_atom_struct(resources)}
  end

  def create(attrs \\ %{}) do
    %Ele{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def change(%Ele{} = ele, attrs) do
    ele
    |> changeset(attrs)
    |> Repo.update()
  end

  def changeset(%Ele{} = ele) do
    changeset(ele, %{})
  end

  @doc false
  def changeset(%Ele{} = app, attrs) do
    app
    |> cast(attrs, [:name, :unique_id, :resources, :contract_types_id])
    |> unique_constraint(:unique_id)
  end
end
