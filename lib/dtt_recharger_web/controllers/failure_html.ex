defmodule DttRechargerWeb.FailureHTML do
  use DttRechargerWeb, :html

  embed_templates "failure_html/*"

  @doc """
  Renders a failure form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def failure_form(assigns)
end
