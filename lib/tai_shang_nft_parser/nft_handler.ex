defmodule TaiShangNftParser.NftHandler do
  alias TaiShangNftParser.ContractTypes
  alias TaiShangNftParser.ImgResources
  alias Utils.StringHandler

  def handle_svg(img_parsed, parser_id, contract_type_name, base_url) do
    %{handler: handler} =
      ContractTypes.get_by_name(contract_type_name)

    "Elixir.TaiShangNftParser.NftHandler."
    |> Kernel.<>(handler)
    |> String.to_atom()
    |> apply(:handle_svg, [img_parsed, parser_id, base_url])
  end

  @doc """
    Some Utils Funcs.
  """
  def insert_payload_to_svg(img_svg, trait, payload) do
    {position, _length} =  :binary.match(img_svg, trait)
    {payload_head, payload_tail}
      = String.split_at(img_svg, position)
    payload_head
    |> Kernel.<>(payload)
    |> Kernel.<>(payload_tail)
  end

  def handle_img_resource(unique_id, _base_url) when is_nil(unique_id) or (unique_id == 0), do: ""

  def handle_img_resource(unique_id, base_url) do
    img_source =
      unique_id
      |> ImgResources.get_by_unique_id()
      |> Map.get(:img_source)

    base_url
    |> StringHandler.handle_url()
    |> Kernel.<>(img_source)
  end

  # +-----------+
  # | Behaviour |
  # +-----------+
  defmodule Behaviour do
    @moduledoc """
    the behaviour of handler.
    """
    @callback handle_svg(
      image_parsed :: String.t(),
      parser_id :: integer(),
      contract_type_name :: atom(),
      base_url :: String.t()
      ) :: :error | String.t()
  end

end
