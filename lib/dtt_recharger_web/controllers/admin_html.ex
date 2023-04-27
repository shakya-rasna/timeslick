defmodule DttRechargerWeb.AdminHTML do
  use DttRechargerWeb, :html

  import DttRechargerWeb.Helpers.RoleHelper

  embed_templates "admin_html/*"

  @doc """
  Renders a admin form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def admin_form(assigns)
end
