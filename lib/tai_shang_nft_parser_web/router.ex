defmodule TaiShangNftParserWeb.Router do
  use TaiShangNftParserWeb, :router
  # for user
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, {TaiShangNftParserWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
    error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api_allow_cross do
    plug CORSPlug, origin: [~r/.*/]
    plug :accepts, ["json"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", TaiShangNftParserWeb do
    pipe_through [:browser]
    live "/", IndexLive, :index
    live "/live/contracts", ContractsLive, :index
    live "/live/parsers", ParserTypesLive, :index
    live "/live/resource_viewer/single_viewer", ResourceViewer.SingleViewerLive, :index
  end

  scope "/logined", TaiShangNftParserWeb do
    pipe_through [:browser, :protected]

  end
  # scope "/logined", TaiShangNftParserWeb do

  # end

  scope "/taishang/api/v1", TaiShangNftParserWeb do
    pipe_through :api_allow_cross

    post "/parse", ParserController, :parse
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaiShangNftParserWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TaiShangNftParserWeb.Telemetry
    end
  end
end
