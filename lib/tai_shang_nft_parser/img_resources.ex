defmodule TaiShangNftParser.ImgResources do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaiShangNftParser.Repo
  alias  TaiShangNftParser.ImgResources,as: Ele

  schema "img_resources" do
    field :name, :string
    field :unique_id, :integer
    field :description, :string
    field :img_source, :string
    timestamps()
  end

  def get_by_id(nil), do: nil
  def get_by_id(ele) do
    Ele
    |> Repo.get_by(id: ele)
    # |> handle_svg()
  end

  def get_by_unique_id(nil), do: nil
  def get_by_unique_id(ele) do
    Ele
    |> Repo.get_by(unique_id: ele)
    # |> handle_svg()
  end

  def get_by_name(nil), do: nil
  def get_by_name(ele) do
    Ele
    |> Repo.get_by(name: ele)
    # |> handle_svg()
  end

  # def handle_svg(ele) do
  #   Map.put(ele, :svg, Base.decode64!(ele.svg_encoded))
  # end

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
    |> cast(attrs, [:name, :description, :img_source, :unique_id])
    |> unique_constraint(:name)
    |> unique_constraint(:unique_id)
  end
end
