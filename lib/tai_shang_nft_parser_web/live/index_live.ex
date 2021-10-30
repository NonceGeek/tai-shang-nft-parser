defmodule TaiShangNftParserWeb.IndexLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParser.ImgResources

  @page_first "1"
  @default_page_size "3"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
      socket
      |> assign(page: 1)
      |> assign(per_page: 3)
    }
  end

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
      page
      |> ImgResources.list(per_page)
    %{
      resources: resources,
      page_title: "Listing ImgResources – Page #{page}"
    }
  end
end
