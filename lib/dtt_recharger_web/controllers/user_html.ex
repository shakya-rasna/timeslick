defmodule DttRechargerWeb.UserHTML do
  use DttRechargerWeb, :html
  require IEx

  import DttRechargerWeb.Helpers.RoleHelper

  embed_templates "user_html/*"

  @doc """
  Renders a user form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :organizations, :list, required: true

  def user_form(assigns)
end
