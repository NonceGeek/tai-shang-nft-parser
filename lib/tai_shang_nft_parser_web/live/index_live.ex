defmodule TaiShangNftParserWeb.IndexLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParserWeb.IndexView
  alias TaiShangNftParser.Resources
  alias TaiShangNftParser.ContractTypes
  alias TaiShangNftParser.Parsers
  alias TaiShangNftParser.ParserTypes
  alias Utils.URIHandler

  @img_type "img"
  @inputs_listen_change [
    "first", "second", "third",
    "fourth", "fifth", "sixth",
    "seventh", "eighth"
  ]

  @default_collection %{
    second_collection:
    Poison.encode!(
    List.duplicate("house_yellow", 4)
    |> Kernel.++ List.duplicate("house_red", 4)
    |> Kernel.++ List.duplicate("house_green", 4)
    |> Kernel.++ List.duplicate("house_black", 2)
    ),
    third_collection:
    Poison.encode!(
      List.duplicate("sky_moon", 4)
      |> Kernel.++ List.duplicate("sky_sun", 4)
      |> Kernel.++ List.duplicate("sky_cloud", 4)
      ),
    fourth_collection:
    Poison.encode!(
      List.duplicate("slogan_amazing", 4)
      |> Kernel.++ List.duplicate("slogan_wow", 4)
      |> Kernel.++ List.duplicate("slogan_cool_guy", 4)
      ),
    first_collection:
    Poison.encode!(
      List.duplicate("ground_soil", 4)
      |> Kernel.++ List.duplicate("ground_sea", 4)
      |> Kernel.++ List.duplicate("ground_grass", 4)
      )
  }
  @init_value "1"

  @page_first "1"
  @default_page_size "15"

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
    resources_in_cart =
      Enum.map(cart_ids, fn img_id ->
        Resources.get_by_id(img_id)
      end)
    resource_selected =
      Enum.fetch!(resources_in_cart, 0)

    payloads =
      init_collections()
      |> Map.merge(init_params())
    {
      :ok,
      socket
      |> assign(step: 3)
      |> assign(form: :payloads)
      |> assign(resources_in_cart: resources_in_cart)
      |> assign(resource_selected: resource_selected)
      |> assign(contract_type_name: contract_type_name)
      |> assign(payloads: payloads)
    }
  end

  def init_collections() do
    @default_collection
  end

  def init_params() do
    @inputs_listen_change
    |> Enum.map(&String.to_atom(&1))
    |> Enum.reduce(%{}, fn key, acc ->
      Map.put(acc, key, @init_value)
    end)
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
      @img_type
      |> Resources.list(page, per_page)
    %{
      resources: resources,
      page_title: "Listing Resources – Page #{page}"
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
    source = Resources.get_by_id(resource_id_int)
    cart_names_new = socket.assigns.cart_names ++ [source.name]
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
      |> Resources.get_by_id()
    {
      :noreply,
      socket
      |> assign(resource_selected: resource_new)
    }
  end

  @impl true
  def handle_event(key, _value, socket)
    when key in ["determine_rule", "submit_rule"] do
    {
      :noreply,
      socket
      |> assign(clicked: key)
    }
  end

  @impl true
  def handle_event("step_3_submit", %{"payloads" => payloads}, socket) do
    do_handle_event(payloads, socket, socket.assigns.clicked)
  end

  def do_handle_event(payloads, socket, "determine_rule") do
    generate_img_by_payloads(payloads, socket)
  end

  def do_handle_event(
    %{"parser_name" => parser_name},
    socket,
    "submit_rule") do
      collection = socket.assigns[:collection]
    if is_nil(collection) do
      # TODO
      {:noreply, socket}
    else
      contract_type_name = socket.assigns.contract_type_name
      {:ok, %{id: id}} =
        ParserTypes.generate(parser_name, collection, contract_type_name)
      {:noreply,
        push_redirect(
        socket,
        to: Routes.parser_types_path(
          socket,
          :index,
          %{parser_id: id})
      )}
    end

  end

  def handle_event("step_3_change",
  %{
    "_target" => ["payloads", input_name],
    "payloads" => payloads
  }, socket)
  when input_name in @inputs_listen_change
  do
    case Integer.parse(payloads[input_name]) do
      :error ->
        {:noreply, socket}
      _else ->
        generate_img_by_payloads(payloads, socket)
    end
  end

  def generate_img_by_payloads(payloads, socket) do
    payloads_atom = ExStructTranslator.to_atom_struct(payloads)
    {payloads_with_line, payloads_with_out_line} =
      split_payloads(payloads_atom)
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
      |> assign(payloads: payloads_atom)
      |> assign(collection: collection)
    }
  end


  def handle_event("step_3_change", _else, socket) do
    {:noreply, socket}
  end

  @doc """
    split_payloads(atom_map())
  """
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
      |> Enum.reject(fn {key, value} ->
        key == :parser_name
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

  def do_generate_collection(:background_collection, name)
    when name == "" or is_nil(name) do
    {
      :background,
      %{collection: [], height: 385, width: 380, x: 0, y: 0}
    }
  end

  def do_generate_collection(:background_collection, name) do
    resource =
      name
      |> String.replace("\"", "")
      |> Resources.get_by_name()
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
        resource = Resources.get_by_name(resources_name)
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
