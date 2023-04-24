defmodule DttRechargerWeb.UserSessionHTML do
  use DttRechargerWeb, :html
  alias DttRecharger.Repo
  alias DttRecharger.Schema.Organization

  embed_templates "user_session_html/*"
end
