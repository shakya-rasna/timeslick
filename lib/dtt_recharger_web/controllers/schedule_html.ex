defmodule DttRechargerWeb.ScheduleHTML do
  use DttRechargerWeb, :html

  embed_templates "schedule_html/*"

  @doc """
  Renders a schedule form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def schedule_form(assigns)
end
