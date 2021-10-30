defmodule TaiShangNftParserWeb.ResourceViewer.SingleViewerLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParser.ImgResources
  @impl true
  def mount(%{"resource_id" => id}, _session, socket) do
    id_int = String.to_integer(id)
    img_resource =
      ImgResources.get_by_unique_id(id_int)

    {
      :ok,
      assign(
        socket,
        img_resource: img_resource)
    }
  end

  @impl true
  def handle_event(_,_, socket) do
    {:noreply, socket}
  end
end
