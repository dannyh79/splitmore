defmodule SplitmoreWeb.Router do
  use SplitmoreWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SplitmoreWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SplitmoreWeb.Plugs.SetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SplitmoreWeb do
    pipe_through :browser

    get "/", PageController, :home

    live_session :default, on_mount: SplitmoreWeb.UserAuth do
      live "/expenses", ExpenseLive.Index, :index
      live "/expenses/new", ExpenseLive.Index, :new
      live "/expenses/:id/edit", ExpenseLive.Index, :edit

      live "/expenses/:id", ExpenseLive.Show, :show
      live "/expenses/:id/show/edit", ExpenseLive.Show, :edit

      live "/groups", GroupLive.Index, :index
      live "/groups/new", GroupLive.Index, :new
      live "/groups/:id/edit", GroupLive.Index, :edit

      live "/groups/:id", GroupLive.Show, :show
      live "/groups/:id/show/edit", GroupLive.Show, :edit
    end
  end

  scope "/auth", SplitmoreWeb do
    pipe_through :browser

    delete "/logout", AuthController, :logout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", SplitmoreWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:splitmore, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SplitmoreWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  if Application.compile_env(:splitmore, :test_routes) do
    scope "/test/api", SplitmoreWeb do
      pipe_through :browser

      get "/login", TestAuthController, :login
    end
  end
end
