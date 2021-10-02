defmodule TaiShangNftParser.NftHandler do

  alias TaiShangNftParser.{ParserTypes, ImgResources}
  alias Utils.StringHandler
  @traits %{
    n: "<text"
    }

  @header %{
    origin: "<svg xmlns=\"http://www.w3.org/2000/svg\" preserveAspectRatio=\"xMinYMin meet\" viewBox=\"0 0 350 350\">",
    replace: "<svg  xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" preserveAspectRatio=\"xMinYMin meet\" viewBox=\"0 0 350 350\">"
  }

  @keys %{
    n: [:first, :second, :third, :fourth, :fifth, :sixth, :seventh, :eighth]
  }

  def build_img_payload(nil, _x, _y, _height, _width), do: nil
  def build_img_payload(img_source, x, y, height, width) do
    "<image xlink:href='#{img_source}' "
    |> Kernel.<>("x='#{x}' y='#{y}' ")
    |> Kernel.<>("height='#{height}' width='#{width}' />")
  end

  @spec handle_svg(binary, any, :n, String.t()) :: binary
  def handle_svg(img_parsed, parser_type_id, :n, base_url) do

    %{resources: resources} = ParserTypes.get_by_unique_id(parser_type_id)

    abstract_nft =
      img_parsed
      |> parser_svg(:n)
      |> insert_background(resources)

    payload_svg =
      Enum.reduce(resources, "", fn {key, payload}, svg_acc ->
        # exp. %{collection: [4], x: 1, y: 1, height: 500, width: 500}
        %{collection: collection, x: x, y: y, height: height, width: width} = payload
        value = Map.get(abstract_nft, key)
        img_source =
          collection
          |> Enum.at(value)
          # |> tap(fn _v ->
          #   IO.puts inspect value
          # end)
          |> handle_img_resource(base_url)


        svg_acc <> build_img_payload(img_source, x, y, height, width)
      end)

    img_parsed
    |> insert_payload_to_svg(@traits.n, payload_svg)
    |> replace_header()
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

  def replace_header(img) do
    String.replace(img, @header.origin, @header.replace)
  end

  def insert_background(abstract_nft, %{background: _background}) do
    Map.put(abstract_nft, :background, 0)
  end

  def parser_svg(img_parsed, :n) do
    value =
      img_parsed
        |> String.split("class=\"base\">")
        |> Enum.drop(1)
        |> Enum.map(&(String.at(&1,0)))
        |> Enum.map(&(String.to_integer(&1)))
    @keys.n
    |> Enum.zip(value)
    |> Enum.into(%{})
  end

  def insert_payload_to_svg(img_svg, trait, payload) do
    {position, _length} =  :binary.match(img_svg, trait)
    {payload_head, payload_tail}
      = String.split_at(img_svg, position)
    payload_head
    |> Kernel.<>(payload)
    |> Kernel.<>(payload_tail)
  end
end
