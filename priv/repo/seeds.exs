# Insert vibes

alias DttRecharger.Repo
alias DttRecharger.Schema.FileType

file_types = ["stock", "order"]

Enum.each(file_types, fn(file_type) ->
  %FileType{}
  |> FileType.changeset(%{type: file_type})
  |> Repo.insert
end)
