defmodule TaiShangNftParserWeb.AsciiPageController do
  use TaiShangNftParserWeb, :controller

  alias TaiShangNftParser.Resources

  def index(conn, %{
    "unique_id" => unique_id}) do
    resource =
      unique_id
      |> String.to_integer()
      |> Resources.get_by_unique_id()
      |> handle_uri()
    render(
      conn,
      "index.html",
      resource: resource,
      layout: {TaiShangNftParserWeb.LayoutView, "simple.html"}
    )
  end

  def handle_uri(%{uri: uri} = resource) do
    handled_uri = do_handle_uri(uri)
    Map.put(resource, :uri, handled_uri)
  end

  def do_handle_uri(uri) do
    uri
    |> String.replace("\\", "\\\\")
    # because it will be handle again in javascript in ascii_page
  end
end
