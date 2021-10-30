defmodule TaiShangNftParserWeb.ParserRulesLive do
  use TaiShangNftParserWeb, :live_view
  alias TaiShangNftParser.ParserRules
  @impl true
  def mount(_params, _session, socket) do
    rules_handled =
      ParserRules.get_all()
    {
      :ok,
      assign(socket, rules: rules_handled)
    }
  end

  @impl true
  def handle_event(_,_, socket) do
    {:noreply, socket}
  end
end
