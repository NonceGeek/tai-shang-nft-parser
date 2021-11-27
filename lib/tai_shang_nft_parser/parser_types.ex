defmodule TaiShangNftParser.ParserTypes do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftParser.Repo
  alias TaiShangNftParser.ParserTypes,as: Ele
  alias TaiShangNftParser.ContractTypes

  schema "parser_types" do
    field :name, :string
    field :unique_id, :integer
    field :resources, :map
    belongs_to :contract_types, ContractTypes
    timestamps()
  end

  def get_by_id(nil), do: nil
  def get_by_id(ele) do
    Ele
    |> Repo.get_by(id: ele)
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
