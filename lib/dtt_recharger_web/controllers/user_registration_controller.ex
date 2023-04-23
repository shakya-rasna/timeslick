defmodule DttRechargerWeb.UserRegistrationController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.AccountOperation
  alias DttRecharger.Schema.User
  alias DttRechargerWeb.UserAuth

  def new(conn, _params) do
    changeset = AccountOperation.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case AccountOperation.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          AccountOperation.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
