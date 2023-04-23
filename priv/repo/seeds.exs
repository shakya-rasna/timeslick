# Insert vibes

alias DttRecharger.Repo
alias DttRecharger.Schema.{FileType, Role, Status}

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
