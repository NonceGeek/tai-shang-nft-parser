defmodule TaiShangNftParserWeb.ContractsLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParser.Contracts
  @impl true
  def mount(_params, _session, socket) do
    contracts_handled =
      Contracts.get_all()
      |> handle_contracts()
    {
      :ok,
      assign(socket, contracts: contracts_handled)
    }
  end

  def handle_contracts(contracts) do
    contracts
  end

  @impl true
  def handle_event(_,_, socket) do
    {:noreply, socket}
  end
end
