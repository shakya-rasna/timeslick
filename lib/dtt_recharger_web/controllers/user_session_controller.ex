defmodule DttRechargerWeb.UserSessionController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{AccountOperation, OrganizationRoleOperation}
  alias DttRechargerWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password, "organization_id" => organization_id} = user_params

    if user = AccountOperation.get_user_by_email_and_password(email, password) do
      if user_org = OrganizationRoleOperation.get_user_org_role(user, organization_id) do
        AccountOperation.increase_signin_count(user)
        OrganizationRoleOperation.increase_signin_count(user_org)
        conn
        |> put_flash(:info, "Welcome back!")
        |> UserAuth.log_in_user(user, user_params)
      else
        render(conn, :new, error_message: "You are not belong to this organization.")
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :new, error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
