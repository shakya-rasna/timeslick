defmodule DttRechargerWeb.RecordHTML do
  use DttRechargerWeb, :html

  embed_templates "record_html/*"

  @doc """
  Renders a record form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def record_form(assigns)
end
