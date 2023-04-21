defmodule DttRechargerWeb.OrderFileHTML do
  use DttRechargerWeb, :html

  embed_templates "order_file_html/*"

  @doc """
  Renders a order form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def import_order_file_form(assigns)
end
