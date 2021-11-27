defmodule TaiShangNftParserWeb.IndexLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParserWeb.IndexView
  alias TaiShangNftParser.ImgResources
  alias TaiShangNftParser.ContractTypes
  alias TaiShangNftParser.Parsers
  alias Utils.URIHandler

  @page_first "1"
  @default_page_size "3"

  @impl true
  def render(assigns) do
    html = "index-step-#{assigns.step}.html"
    IndexView.render(html, assigns)
  end

  @impl true
  def mount(
    %{
      "step"  => "3",
      "contract_type_name" => contract_type_name,
      "encoded_carts" => encoded_carts
      }, _session, socket) do
    cart_ids =
      encoded_carts
      |> Base.url_decode64!()
      |> Poison.decode!()
    resources =
      Enum.map(cart_ids, fn img_id ->
        ImgResources.get_by_id(img_id)
      end)
    resource_selected =
      Enum.fetch!(resources, 0)
    {
      :ok,
      socket
      |> assign(step: 3)
      |> assign(form: :payloads)
      |> assign(resources: resources)
      |> assign(resource_selected: resource_selected)
      |> assign(contract_type_name: contract_type_name)
    }
  end

  def mount(
      %{
        "step" => "2",
        "contract_type_name" => contract_type_name
        }, _session, socket) do

    {
      :ok,
      socket
      |> assign(step: 2)
      |> assign(carts: [])
      |> assign(cart_names: [])
      |> assign(page: @page_first)
      |> assign(per_page: @default_page_size)
      |> assign(form: :payloads)
      |> assign(contract_type_name: contract_type_name)
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
      page_title: "Listing ImgResources – Page #{page}"
    }
  end

  def mount(%{}, _session, socket) do
    contract_type_names =
      ContractTypes.get_all()
      |> Enum.map(&(&1.name))
    contract_type_name_selected =
      Enum.fetch!(contract_type_names, 0)
    contracts =
      contract_type_name_selected
      |> ContractTypes.get_by_name()
      |> ContractTypes.preload()
      |> Map.get(:contracts)

    {
      :ok,
      socket
      |> assign(contract_type_names: contract_type_names)
      |> assign(contract_type_name_selected: contract_type_name_selected)
      |> assign(form: :payloads)
      |> assign(step: 1)
      |> assign(contracts: contracts)
    }
  end

  @impl true
  def handle_event(
    "step_1_change",
    %{"payloads" => %{"contract_type_name_selected" => contract_type_name_selected}},
    socket) do
    contracts =
      contract_type_name_selected
      |> ContractTypes.get_by_name()
      |> ContractTypes.preload()
      |> Map.get(:contracts)
    {
      :noreply,
      socket
      |> assign(contracts: contracts)
    }
  end

  @impl true
  def handle_event("step_1_submit", payload, socket) do
    contract_type_name =
      socket.assigns.contract_type_name_selected
    {
      :noreply,
      socket
      |> push_redirect(
        to: Routes.index_path(socket, :index, %{contract_type_name: contract_type_name, step: 2})
      )
    }
  end

  @impl true
  def handle_event("step_2_submit", payload, socket) do
    encoded_carts =
      socket.assigns.carts
      |> Poison.encode!()
      |> Base.url_encode64()
    {
      :noreply,
      socket
      |> push_redirect(
        to: Routes.index_path(
          socket,
          :index,
          %{
            contract_type_name: socket.assigns.contract_type_name,
            step: 3,
            encoded_carts: encoded_carts
          })
      )
    }
  end

  @impl true
  def handle_event("add_to_my_collection", %{"resource_id" => resource_id}, socket) do
    resource_id_int = String.to_integer(resource_id)
    carts_new = socket.assigns.carts ++ [resource_id_int]
    img_source = ImgResources.get_by_id(resource_id_int)
    cart_names_new = socket.assigns.cart_names ++ [img_source.name]
    {
      :noreply,
      socket
      |> assign(carts: carts_new)
      |> assign(cart_names: cart_names_new)
    }
  end

  @impl true
  def handle_event("change_selected_component", %{"resource_id" => resource_id}, socket) do
    resource_new =
      resource_id
      |> String.to_integer()
      |> ImgResources.get_by_id()
    {
      :noreply,
      socket
      |> assign(resource_selected: resource_new)
    }
  end

  @impl true
  def handle_event("step_3_submit", %{"payloads" => payloads}, socket) do
    {payloads_with_line, payloads_with_out_line} =
      payloads
      |> ExStructTranslator.to_atom_struct()
      |> split_payloads()
    collection = generate_collection(payloads_with_line)
    {image, image_parsed} =
      Parsers.parse_handle_rebuild_nft_for_preview(
        socket.assigns.contract_type_name,
        collection,
        payloads_with_out_line
      )
    {
      :noreply,
      socket
      |> assign(image_parsed: image_parsed)
      |> assign(image: image)
      |> assign(payloads: payloads_with_line)
    }
  end

  def split_payloads(payloads) do
    payloads_with_out_line =
      payloads
      |> Enum.reject(fn {key, value} ->
        line_in_key?(key)
      end)
      |> Enum.into(%{})
      payloads_with_line =
      payloads
      |> Enum.filter(fn {key, value} ->
        line_in_key?(key)
      end)
      |> Enum.into(%{})

    {payloads_with_line, payloads_with_out_line}
  end

  def line_in_key?(key) when is_binary(key) do
    String.contains?(key, "_")
  end

  def line_in_key?(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> String.contains?("_")
  end
  def generate_collection(payloads) do
    payloads
    |> Enum.map(fn {key, value} ->
      do_generate_collection(key, value)
    end)
    |> Enum.into(%{})
  end
  def do_generate_collection(:background_collection, name) do
    resource =
      name
      |> String.replace("\"", "")
      |> ImgResources.get_by_name()
    {
      :background,
      %{collection: [resource.unique_id], height: 385, width: 380, x: 0, y: 0}
    }
  end

  def do_generate_collection(key, resources_name_list_str) do
    [key_handled, _] =
      key
      |> Atom.to_string()
      |> String.split("_")
    key_handled_atom = String.to_atom(key_handled)
    resources_unique_ids =
      resources_name_list_str
      |> handle_list()
      |> Enum.map(fn resources_name ->
        resource = ImgResources.get_by_name(resources_name)
        resource.unique_id
      end)
    {
      key_handled_atom,
      %{collection: resources_unique_ids, height: 385, width: 380, x: 0, y: 0}
    }

  end

  def handle_list(""), do: []
  def handle_list(list_str), do: Poison.decode!(list_str)
end
