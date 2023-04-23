defmodule DttRechargerWeb.Router do
  use DttRechargerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DttRechargerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DttRechargerWeb do
    pipe_through :browser

    get "/", RecordController, :index

    resources "/records", RecordController
    resources "/stock_files", StockFileController
    get "/new_upload_file", UploadFileController, :new_upload_file, as: :new_upload_file
    post "/import_order_records", UploadFileController, :save_file_and_import_record, as: :save_file_and_import_record
  end

  # Other scopes may use custom stacks.
  # scope "/api", DttRechargerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dtt_recharger, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DttRechargerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
