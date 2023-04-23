defmodule DttRechargerWeb.UploadFileHTML do
  use DttRechargerWeb, :html

  embed_templates "upload_file_html/*"

  @doc """
  Renders a order form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def import_order_file_form(assigns)
  def import_stock_file_form(assigns)
end
