defmodule TaiShangNftParser.Parsers do
  alias TaiShangNftParser.{ContractTypes, NftHandler}
  alias Utils.URIHandler
  @prefix %{
    img: "data:image/svg+xml;base64,",
    json: "data:application/json;base64,"}

  @doc """
    result example:

    `
    %{
      description: "N is just numbers.",
      image: "data:image/svg+xml;base64,PHN2ZyAgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgcHJlc2VydmVBc3BlY3RSYXRpbz0ieE1pbllNaW4gbWVldCIgdmlld0JveD0iMCAwIDM1MCAzNTAiPjxzdHlsZT4uYmFzZSB7IGZpbGw6IHdoaXRlOyBmb250LWZhbWlseTogc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgfTwvc3R5bGU+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0iYmxhY2siIC8+PGltYWdlIHhsaW5rOmhyZWY9J3N2Z19yZXNvdXJjZXMvYmV3YXRlcl9mbG93aW5nLmdpZicgeD0nMCcgeT0nMCcgaGVpZ2h0PSczODUnIHdpZHRoPSczODAnIC8+PGltYWdlIHhsaW5rOmhyZWY9J3N2Z19yZXNvdXJjZXMvYmV3YXRlcl9mbG93aW5nLmdpZicgeD0nMCcgeT0nMCcgaGVpZ2h0PSczODUnIHdpZHRoPSczODAnIC8+PHRleHQgeD0iMTAiIHk9IjIwIiBjbGFzcz0iYmFzZSI+ODwvdGV4dD48dGV4dCB4PSIxMCIgeT0iNDAiIGNsYXNzPSJiYXNlIj40PC90ZXh0Pjx0ZXh0IHg9IjEwIiB5PSI2MCIgY2xhc3M9ImJhc2UiPjg8L3RleHQ+PHRleHQgeD0iMTAiIHk9IjgwIiBjbGFzcz0iYmFzZSI+OTwvdGV4dD48dGV4dCB4PSIxMCIgeT0iMTAwIiBjbGFzcz0iYmFzZSI+NzwvdGV4dD48dGV4dCB4PSIxMCIgeT0iMTIwIiBjbGFzcz0iYmFzZSI+NTwvdGV4dD48dGV4dCB4PSIxMCIgeT0iMTQwIiBjbGFzcz0iYmFzZSI+OTwvdGV4dD48dGV4dCB4PSIxMCIgeT0iMTYwIiBjbGFzcz0iYmFzZSI+OTwvdGV4dD48L3N2Zz4=",
      name: "N #2"
    }
    `
  """
  @spec parse_handle_rebuild_nft_for_preview(String.t(), map(), map()) :: map()
  def parse_handle_rebuild_nft_for_preview(contract_type_name, resources, params) do
    %{example_svg: payload_raw} =
      contract_type =
        ContractTypes.get_by_name(contract_type_name)
    %{payload: payload, img_parsed: img_parsed} =
      parse_nft(payload_raw)

    NftHandler.handle_svg_for_preview(
      img_parsed,
      resources,
      contract_type,
      "/images/",
      params
      )
  end
  @doc """
    the enter of parser controller.
  """
  def parse_handle_rebuild_nft(handler_id, contract_type_name, payload_raw, base_url) do
    %{payload: payload, img_parsed: img_parsed}
      = parse_nft(payload_raw)

    rebuild_nft(
      payload,
      NftHandler.handle_svg(img_parsed, handler_id, contract_type_name, base_url)
    )
  end

  def parse_nft(payload_raw) do
    %{image: img_raw} =
      payload =
        URIHandler.decode_uri(payload_raw)
    img_parsed =
      URIHandler.decode_uri(img_raw)
    %{payload: payload, img_parsed: img_parsed}
  end

  def rebuild_nft(payload, img_handled) do
    img_encoded = encode_img(img_handled)
    %{payload | image: img_encoded}
  end

  def encode_img(img_handled) do
    @prefix.img <> Base.encode64(img_handled)
  end

  def encode_json(json_str) do
    @prefix.json <> Base.encode64(json_str)
  end
end
