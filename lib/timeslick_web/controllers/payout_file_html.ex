defmodule TimeslickWeb.PayoutFileHTML do
  use TimeslickWeb, :html

  embed_templates "payout_file_html/*"

  @doc """
  Renders a payout form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def import_payout_form(assigns)
end
