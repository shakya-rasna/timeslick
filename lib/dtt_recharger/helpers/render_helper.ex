defmodule DttRecharger.Helpers.RenderHelper do
  use DttRechargerWeb, :controller

  def render_error_default(conn, error) do
    put_flash(conn, :error, error ) |> redirect(to: ~p"/order_files")
  end

  def user_validation_error(conn, error) do
    put_flash(conn, :error, error ) |> redirect(to: ~p"/users/new")
  end
end
