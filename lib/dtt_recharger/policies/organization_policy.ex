defmodule DttRecharger.Policies.OrganizationPolicy do

  def index(current_user_role) do
    if current_user_role == "admin", do: true, else: false
  end

  def create(current_user) do
    DttRecharger.Policies.OrganizationPolicy.index(current_user)
  end
end
