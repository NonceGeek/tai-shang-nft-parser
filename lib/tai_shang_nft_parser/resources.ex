defmodule TaiShangNftParser.Resources do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias TaiShangNftParser.Repo
  alias Utils.ArweaveNode
  alias  TaiShangNftParser.Resources,as: Ele

  schema "resources" do
    field :name, :string
    field :unique_id, :integer
    field :description, :string
    field :source, :string
    field :uri, :string
    field :arweave_tx_id, :string
    field :type, :string, default: "img"
    # types including: img, ascii, voxel.
    # correspond to arweave tags:
    # image/*, text/ascii, resource/vox
    timestamps()
  end

  def list(type, current_page, per_page) do
    Repo.all(
      from e in Ele,
        where: e.type == ^type,
        offset: ^((current_page - 1) * per_page),
        limit: ^per_page
    )
  end

  def list(current_page, per_page) do
    Repo.all(
      from e in Ele,
        offset: ^((current_page - 1) * per_page),
        limit: ^per_page
    )
  end

  def get_by_type(type) do
    Repo.all(
      from e in Ele,
        where: e.type == ^type
    )
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

  def create(attrs = %{arweave_tx_id: arweave_tx_id}, :onchain) do
    ArweaveNode.get_node()
    |> ArweaveSdkEx.get_content_in_tx(arweave_tx_id)
    %Ele{}
    |> changeset(attrs)
    |> Repo.insert()
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
    |> cast(attrs, [:name, :description, :source, :unique_id, :arweave_tx_id, :uri, :type])
    |> unique_constraint(:name)
    |> unique_constraint(:unique_id)
  end
end
