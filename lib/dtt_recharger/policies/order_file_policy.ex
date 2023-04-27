defmodule DttRecharger.Policies.OrderFilePolicy do
  def index(current_user_role) do
    check_role(current_user_role)
  end

  def create(current_user_role) do
    check_role(current_user_role)
  end

  def edit(current_user_role) do
    check_role(current_user_role)
  end

  def update(current_user_role) do
    check_role(current_user_role)
  end

  def new(current_user_role) do
    check_role(current_user_role)
  end

  def delete(current_user_role) do
    check_role(current_user_role)
  end

  def show(current_user_role) do
    check_role(current_user_role)
  end

  def authorize_payouts(current_user_role) do
    roles = ["superadmin", "admin", "authorizer"]
    if Enum.member?(roles, current_user_role), do: true, else: false
  end

  defp check_role(role) do
    roles = ["superadmin", "admin", "uploader", "authorizer"]
    if Enum.member?(roles, role), do: true, else: false
  end
end
