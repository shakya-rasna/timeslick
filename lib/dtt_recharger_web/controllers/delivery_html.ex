defmodule DttRechargerWeb.DeliveryHTML do
  use DttRechargerWeb, :html

  embed_templates "delivery_html/*"

  @doc """
  Renders a delivery form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def delivery_form(assigns)
end
