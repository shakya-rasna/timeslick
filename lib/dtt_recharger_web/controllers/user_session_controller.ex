defmodule DttRechargerWeb.UserSessionController do
  use DttRechargerWeb, :controller

  alias DttRecharger.Operations.{AccountOperation, OrganizationRoleOperation, UserRoleOperation}
  alias DttRechargerWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def admin_new(conn, _params) do
    render(conn, :admin_new, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    if user = AccountOperation.get_user_by_email_and_password(user_params["email"], user_params["password"]) do
      if user_role = UserRoleOperation.get_user_role!(user) do
        user_org = if is_nil(user_params["organization_id"]), do: nil, else: OrganizationRoleOperation.get_user_org_role(user, user_params["organization_id"])
        cond do
          user_role == "user" &&  user_org != nil ->
            AccountOperation.increase_signin_count(user)
            OrganizationRoleOperation.increase_signin_count(user_org)
            conn
            |> put_flash(:info, "Welcome back!")
            |> UserAuth.log_in_user(user, user_params)
          user_role == "user" &&  user_org == nil ->
            render(conn, :new, error_message: "You are not belong to this organization.")
        end
      else
        render(conn, :new, error_message: "Something went wrong. Please try again")
      end
    else
      render(conn, :new, error_message: "Invalid email or password")
    end
  end

  def admin_create(conn, %{"user" => user_params}) do
    if user = AccountOperation.get_user_by_email_and_password(user_params["email"], user_params["password"]) do
      if user_role = UserRoleOperation.get_user_role!(user) do
        if Enum.member?(["superadmin", "admin"], user_role) do
          AccountOperation.increase_signin_count(user)
            conn
            |> put_flash(:info, "Welcome back!")
            |> UserAuth.log_in_user(user, user_params)
        else
          render(conn, :admin_new, error_message: "You are not allowed to perform this action")
        end
      else
        render(conn, :admin_new, error_message: "Something went wrong. Please try again")
      end
    else
      render(conn, :admin_new, error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
