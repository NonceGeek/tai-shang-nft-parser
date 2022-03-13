defmodule TaiShangNftParserWeb.ResourceViewer.AsciiViewerLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParser.Resources

  @html_content File.read!("lib/tai_shang_nft_parser_web/templates/ascii_page/index.html.eex")

  @impl true
  def mount(%{"unique_id" => id}, _session, socket) do

    resource =
      id
      |> String.to_integer()
      |> Resources.get_by_unique_id()
    html = handle_html(@html_content, resource)
    # IO.puts inspect html
    {
      :ok,
      socket
      |> assign(
        unique_id: id,
        html: html
    )}
  end

  @impl true
  def handle_event(_,_, socket) do
    {:noreply, socket}
  end

  def handle_html(html_source, resource) do
    html_source
    |> String.replace("<%= @resource.name %>", resource.name)
    |> String.replace("<%= @resource.description %>", resource.description)
    |> String.replace("<%= @resource.uri %>", handle_uri(resource.uri))
  end

  def handle_uri(uri) do
    uri
    |> String.replace("\\", "\\\\")
    # because it will be handle again in javascript in ascii_page
  end
end
