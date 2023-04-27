# Insert vibes

alias DttRecharger.Repo
alias DttRecharger.Schema.{User, FileType, Role, Status, Organization}

file_types = ["stock", "order"]
roles = ["superadmin", "admin", "uploader", "authorizer"]
statuses = ["pending"]

Enum.each(file_types, fn(file_type) ->
  %FileType{}
  |> FileType.changeset(%{type: file_type})
  |> Repo.insert
end)

Enum.each(roles, fn(role) ->
  %Role{}
  |> Role.changeset(%{name: role})
  |> Repo.insert
end)

Enum.each(statuses, fn(status) ->
  %Status{}
  |> Status.changeset(%{name: status})
  |> Repo.insert
end)

organizations = ["Gurzu"]
Enum.each(organizations, fn(organization) ->
  %Organization{}
  |> Organization.changeset(%{name: organization})
  |> Repo.insert
end)

# super admin
email = "superadmin@gurzu.com"
user = Repo.get_by(User, email: email)
organizations = Repo.all(Organization)
if is_nil(user) do
  %User{}
    |> User.registration_changeset(%{email: email, first_name: "Gurzu",
                                     last_name: "Inc", password: "Gurzu@123",
                                     organization_roles: Enum.map(organizations, fn organization ->
                                       %{organization_id: organization.id,
                                         role_id: Repo.get_by(Role, %{name: "superadmin"}).id} end)})
    |> Repo.insert!
end
