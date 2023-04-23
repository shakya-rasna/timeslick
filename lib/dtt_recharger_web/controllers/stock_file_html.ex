defmodule DttRechargerWeb.StockFileHTML do
  use DttRechargerWeb, :html

  embed_templates "stock_file_html/*"

  @doc """
  Renders a stock_file form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def stock_file_form(assigns)
end
