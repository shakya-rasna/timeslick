defmodule DttRechargerWeb.Router do
  use DttRechargerWeb, :router

  import DttRechargerWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DttRechargerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :fetch_current_organization
  end

  pipeline :api do
    plug :accepts, ["json"]
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

  ## Authentication routes

  scope "/", DttRechargerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    # get "/users/register", UserRegistrationController, :new
    # post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", DttRechargerWeb do
    pipe_through [:browser, :require_authenticated_user]

    #root path
    get "/", UserController, :index

    # User setting
    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    # Organization
    resources "/organizations", OrganizationController, except: [:delete]
    get "/my_organization", OrganizationController, :my_organization

    # Users
    resources "/users", UserController

    # Orders and payouts
    resources "/order_files", OrderFileController, except: [:new, :edit, :update, :delete] do
      get "/payouts", RecordController, :list_loan_payouts
      post "/authorize_payouts", OrderFileController, :authorize_payouts
    end
    get "/import_orders", UploadFileController, :new_order_file, as: :new_order_file
    post "/import_order_records", UploadFileController, :save_file_and_import_record, as: :save_file_and_import_record
    resources "/records", RecordController, except: [:new, :create]


    # Stocks
    resources "/stock_files", StockFileController, except: [:new, :edit, :update, :delete] do
      get "/stocks", StockItemController, :list_stocks
    end
    get "/import_stocks", UploadFileController, :new_stock_file, as: :new_stock_file
    post "/import_stock_items", UploadFileController, :save_file_and_import_stock, as: :save_file_and_import_stock
    resources "/stock_items", StockItemController, except: [:new, :create]

    # Products
    resources "/products", ProductController

    # Deliveries
    resources "/deliveries", DeliveryController, except: [:new, :create, :edit, :update, :delete]
  end

  scope "/", DttRechargerWeb do
    pipe_through [:browser]

    delete "/log_out", UserSessionController, :delete
    # get "/users/confirm", UserConfirmationController, :new
    # post "/users/confirm", UserConfirmationController, :create
    # get "/users/confirm/:token", UserConfirmationController, :edit
    # post "/users/confirm/:token", UserConfirmationController, :update
  end
end
