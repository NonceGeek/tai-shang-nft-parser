defmodule TaiShangNftParserWeb.ParserController do
  use TaiShangNftParserWeb, :controller
  alias TaiShangNftParser.Parsers

  @resp_success %{
    error_code: 0,
    error_msg: "success",
    result: ""
  }

  # @resp_failure %{
  #   error_code: 1,
  #   error_msg: "",
  #   result: ""
  # }

  def parse(
    conn,
    %{
      "handler_id" => handler_id,
      "type" => type,
      "token_uri" => payload,
      "base_url" => base_url
    }) do

    # payload_atom_struct =
    #   ExStructTranslator.to_atom_struct(payload)

    result =
      Parsers.parse_handle_rebuild_nft(
        handler_id,
        type,
        payload,
        base_url
        )

    payload =
      @resp_success
      |> Map.put(:result, result)
    json(conn, payload)
  end

end
