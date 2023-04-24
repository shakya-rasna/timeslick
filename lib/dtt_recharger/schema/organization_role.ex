defmodule DttRecharger.Schema.OrganizationRole do
  use Ecto.Schema
  import Ecto.Changeset
  alias DttRecharger.Schema.OrganizationRole

  schema "organization_roles" do
    field :sign_in_count, :integer, default: 0
    belongs_to :user, DttRecharger.Schema.User
    belongs_to :organization, DttRecharger.Schema.Organization
    belongs_to :role, DttRecharger.Schema.Role

    timestamps()
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:user_id, :organization_id, :role_id])
    |> validate_required([:organization_id, :role_id])
    |> unique_constraint(:organization_roles_user_id_organization_id_index)
    |> unique_constraint(:organization_roles_user_id_organization_id_role_id_index)
  end

  def sign_in_count_changeset(%OrganizationRole{} = org_role, attrs) do
    org_role
    |> cast(attrs, [:sign_in_count])
  end
end
