defmodule DttRecharger.Policies.UploadFilePolicy do
  def new_order_file(current_user_role) do
    check_role(current_user_role)
  end

  def save_file_and_import_record(current_user_role) do
    check_role(current_user_role)
  end

  def save_file_and_import_stock(current_user_role) do
    check_role(current_user_role)
  end

  defp check_role(role) do
    roles = ["superadmin", "admin", "user"]
    if Enum.member?(roles, role), do: true, else: false
  end
end
