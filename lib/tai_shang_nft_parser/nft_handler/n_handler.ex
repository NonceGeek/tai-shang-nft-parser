defmodule TaiShangNftParser.NftHandler.NHandler do
  alias TaiShangNftParser.NftHandler
  alias TaiShangNftParser.ParserTypes

  alias TaiShangNftParser.NftHandler.Behaviour, as: HandlerBehaviour

  @behaviour HandlerBehaviour # necessary for behaviour

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

  def handle_img_by_params(img_parsed, params) do
    Enum.reduce(
      params,
      img_parsed,
      fn {key, value}, acc ->
        key_handled =
          handle_key(key)
        value_handled =
          handle_value(value)
        String.replace(acc, key_handled, value_handled)
      end)
  end

  def handle_key(key) do
    "\#{"<> "#{key}" <> "}"
  end
  def handle_value(value) when is_integer(value) do
    Integer.to_string(value)
  end
  def handle_value(value), do: value


  @impl HandlerBehaviour
  def handle_svg(img_parsed, parser_type_id, base_url) do
    %{resources: resources} = ParserTypes.get_by_unique_id(parser_type_id)
    do_handle_svg(img_parsed, resources, base_url)
  end

  def build_img_payload(nil, _x, _y, _height, _width), do: nil
  def build_img_payload(img_source, x, y, height, width) do
    "<image xlink:href='#{img_source}' "
    |> Kernel.<>("x='#{x}' y='#{y}' ")
    |> Kernel.<>("height='#{height}' width='#{width}' />")
  end

  @spec do_handle_svg(String.t(), map(), String.t()) :: binary
  def do_handle_svg(img_parsed, resources, base_url) do
    abstract_nft =
      img_parsed
      |> parser_svg()
      |> insert_background(resources)
    payload_svg =
      Enum.reduce(resources, "", fn {key, payload}, svg_acc ->
        # exp. %{collection: [4], x: 1, y: 1, height: 500, width: 500}
        %{collection: collection, x: x, y: y, height: height, width: width} = payload
        value = Map.get(abstract_nft, key)
        img_source =
          collection
          |> Enum.at(value)
          |> NftHandler.handle_img_resource(base_url)


        svg_acc <> build_img_payload(img_source, x, y, height, width)
      end)

    result =
      img_parsed
      |> NftHandler.insert_payload_to_svg(@traits.n, payload_svg)
      |> replace_header()

    result
  end

  def replace_header(img) do
    String.replace(img, @header.origin, @header.replace)
  end

  def insert_background(abstract_nft, %{background: _background}) do
    Map.put(abstract_nft, :background, 0)
  end

  def parser_svg(img_parsed) do
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


end
