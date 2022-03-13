defmodule TaiShangNftParserWeb.AsciiGalleryLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParser.Resources

  @ascii_type "ascii"
  @page_first "1"
  @default_page_size "20"

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      socket
    }
  end

  def handle_contracts(contracts) do
    contracts
  end

  @impl true
  def handle_event(_,_, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {page, ""} = Integer.parse(params["page"] || @page_first)
    {per_page, ""} = Integer.parse(params["per_page"] || @default_page_size)
    payload = fetch(page, per_page)
    {
      :noreply,
      socket
      |> assign(page: page)
      |> assign(payload)
    }
  end

  defp fetch(page, per_page) do
    resources =
      @ascii_type
      |> Resources.list(page, per_page)
    %{
      resources: resources,
      page_title: "Listing Resources – Page #{page}"
    }
  end
end
