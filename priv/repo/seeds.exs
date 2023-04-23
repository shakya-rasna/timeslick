# Insert vibes

alias DttRecharger.Repo
alias DttRecharger.Schema.{FileType, Status}

file_types = ["stock", "order"]

Enum.each(file_types, fn(file_type) ->
  %FileType{}
  |> FileType.changeset(%{type: file_type})
  |> Repo.insert
end)

statuses = ["pending"]

Enum.each(statuses, fn(status) ->
  %Status{}
  |> Status.changeset(%{name: status})
  |> Repo.insert
end)
