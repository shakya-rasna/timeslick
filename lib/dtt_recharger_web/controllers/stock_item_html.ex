defmodule DttRechargerWeb.StockItemHTML do
  use DttRechargerWeb, :html

  embed_templates "stock_item_html/*"

  @doc """
  Renders a stock_item form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def stock_item_form(assigns)
end
