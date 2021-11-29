defmodule TaiShangNftParserWeb.ParserTypesLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParser.ParserTypes

  @domain  Application.get_env(:tai_shang_nft_parser, TaiShangNftParserWeb.Endpoint)[:url][:host]
  @example_payload %{
    "token_uri" => "data:application/json;base64,eyJuYW1lIjogIk4gIzIzMyIsICJkZXNjcmlwdGlvbiI6ICJOIGlzIGp1c3QgbnVtYmVycy4iLCAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNDhjM1I1YkdVK0xtSmhjMlVnZXlCbWFXeHNPaUIzYUdsMFpUc2dabTl1ZEMxbVlXMXBiSGs2SUhObGNtbG1PeUJtYjI1MExYTnBlbVU2SURFMGNIZzdJSDA4TDNOMGVXeGxQanh5WldOMElIZHBaSFJvUFNJeE1EQWxJaUJvWldsbmFIUTlJakV3TUNVaUlHWnBiR3c5SW1Kc1lXTnJJaUF2UGp4MFpYaDBJSGc5SWpFd0lpQjVQU0l5TUNJZ1kyeGhjM005SW1KaGMyVWlQakV3UEM5MFpYaDBQangwWlhoMElIZzlJakV3SWlCNVBTSTBNQ0lnWTJ4aGMzTTlJbUpoYzJVaVBqazhMM1JsZUhRK1BIUmxlSFFnZUQwaU1UQWlJSGs5SWpZd0lpQmpiR0Z6Y3owaVltRnpaU0krTlR3dmRHVjRkRDQ4ZEdWNGRDQjRQU0l4TUNJZ2VUMGlPREFpSUdOc1lYTnpQU0ppWVhObElqNDJQQzkwWlhoMFBqeDBaWGgwSUhnOUlqRXdJaUI1UFNJeE1EQWlJR05zWVhOelBTSmlZWE5sSWo0MFBDOTBaWGgwUGp4MFpYaDBJSGc5SWpFd0lpQjVQU0l4TWpBaUlHTnNZWE56UFNKaVlYTmxJajR4TVR3dmRHVjRkRDQ4ZEdWNGRDQjRQU0l4TUNJZ2VUMGlNVFF3SWlCamJHRnpjejBpWW1GelpTSStNand2ZEdWNGRENDhkR1Y0ZENCNFBTSXhNQ0lnZVQwaU1UWXdJaUJqYkdGemN6MGlZbUZ6WlNJK01UQThMM1JsZUhRK1BDOXpkbWMrIn0=",
    "base_url" => "https://bewater.leeduckgo.com"
  }

  @impl true
  def mount(%{"parser_id" => id_str}, _session, socket) do
    parser =
      id_str
      |> String.to_integer()
      |> ParserTypes.get_by_id()
    do_mount(socket, [parser])
  end
  def mount(%{}, _session, socket) do
    parsers =
      ParserTypes.get_all()
    do_mount(socket, parsers)
  end

  def do_mount(socket, parsers) do
    parsers_handled =
      parsers
      |> Enum.map(fn parser ->
        parser
        |> Map.put(:url, generate_url(parser))
        |> Map.put(:url_ar, generate_url(parser, :arweave))
      end)
    {
      :ok,
      socket
      |> assign(parsers: parsers_handled)
    }
  end

  @impl true
  def handle_event(_,_, socket) do
    {:noreply, socket}
  end

  def generate_url(parser) do
    "#{@domain}/taishang/api/v1/parse?handler_id=#{parser.unique_id}&type=#{parser.contract_types.name}"
  end

  def generate_url(parser, :arweave) do
    parser
    |> generate_url()
    |> Kernel.<>("&resources_on=arweave")
  end

end
