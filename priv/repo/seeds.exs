# Insert vibes

alias DttRecharger.Repo
alias DttRecharger.Schema.{User, FileType, Role, Status}

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

# super admin
email = "superadmin@gurzu.com"
user = Repo.get_by(User, email: email)
if is_nil(user) do
  %User{}
    |> User.registration_changeset(%{email: email, first_name: "Gurzu Inc",
                                     last_name: "Inc", password: "Gurzu@123",
                                     user_role: %{role_id: Repo.get_by(Role, %{name: "superadmin"}).id}})
    |> Repo.insert
end
