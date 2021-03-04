defmodule RocketpayWeb.Router do
  use RocketpayWeb, :router
  import Plug.BasicAuth

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :basic_auth, Application.compile_env(:rocketpay, :basic_auth)
  end

  scope "/api", RocketpayWeb do
    pipe_through :api
    # get
    get "/:filename", WelcomeController, :index
    # post
    post "/users", UsersController, :create # Rota para usuários
  end

  scope "/api", RocketpayWeb do
    pipe_through [:api, :auth]
    #post
    post "/accounts/:id/deposit", AccountsController, :deposit # Rota para depósitos
    post "/accounts/:id/withdraw", AccountsController, :withdraw # Rota para saques
    post "/accounts/transaction", AccountsController, :transaction # Rota para a transação
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: RocketpayWeb.Telemetry
    end
  end
end
