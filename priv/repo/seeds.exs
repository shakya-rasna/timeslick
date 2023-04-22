# Insert vibes

alias DttRecharger.Repo
alias DttRecharger.Schema.{FileType, Role}

file_types = ["stock", "order"]

Enum.each(file_types, fn(file_type) ->
  %FileType{}
  |> FileType.changeset(%{type: file_type})
  |> Repo.insert
end)

roles = ["superadmin", "admin", "uploader", "authorizer"]

Enum.each(roles, fn(role) ->
  %Role{}
  |> Role.changeset(%{name: role})
  |> Repo.insert
end)
