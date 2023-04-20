defmodule TimeslickWeb.PayoutHTML do
  use TimeslickWeb, :html

  embed_templates "payout_html/*"

  @doc """
  Renders a payout form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def payout_form(assigns)
end
