defmodule TaiShangNftParser.Parsers do
  alias TaiShangNftParser.NftHandler

  @padding_str %{level_1: 29, level_2: 26}

  @doc """
    the enter of parser controller.
  """
  def parse_handle_rebuild_nft(handler_id, nft_type, payload_raw, base_url) do
    %{payload: payload, img_parsed: img_parsed}
      = parse_nft(nft_type, payload_raw)

    rebuild_nft(
      payload,
      NftHandler.handle_svg(img_parsed, handler_id, nft_type, base_url)
    )
  end
  def parse_nft(nft_type, payload_raw) do
    %{image: img_raw}
    = payload
    = payload_raw
      |> String.slice(@padding_str.level_1..-1)
      |> Base.decode64!()
      |> Poison.decode!()
      |> ExStructTranslator.to_atom_struct()
    %{payload: payload, img_parsed: parse_img(img_raw)}
  end

  def rebuild_nft(payload, img_handled) do
    img_encoded = encode_img(img_handled)
    %{payload | image: img_encoded}
  end

  def parse_img(img_raw) do
    img_raw
    |> String.slice(@padding_str.level_2..-1)
    |> Base.decode64!()
  end

  def encode_img(img_handled), do: Base.encode64(img_handled)
end
