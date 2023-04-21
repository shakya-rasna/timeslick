defmodule DttRechargerWeb.UploadFileHTML do
  use DttRechargerWeb, :html

  embed_templates "upload_file_html/*"

  @doc """
  Renders a order form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def import_upload_file_form(assigns)
end
