# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cklist.Repo.insert!(%Cklist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Cklist.{Repo, Accounts, Checklists}

roman = Repo.insert!(%Accounts.User{
  email: "roman@cklist.org",
  password: "romanholiday",
  hashed_password: Bcrypt.hash_pwd_salt("romanholiday"),
  confirmed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})

aaron = Repo.insert!(%Accounts.User{
  email: "aaron@cklist.org",
  password: "aaronholiday",
  hashed_password: Bcrypt.hash_pwd_salt("aaronholiday"),
  confirmed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})

Repo.insert!(%Checklists.Checklist{
  title: "First things first!",
  description: "Sequential checklist",
  access: :public,
  user_id: aaron.id,

  document: %{
    version: "0.1",
    sequential: true,
    steps: [
      %{ name: "First thing" },
      %{ name: "Second thing" },
      %{ name: "Third thing" },
    ]
  }
})

Repo.insert!(%Checklists.Checklist{
  title: "Routine",
  description: "Morning todo list",
  access: :personal,
  user_id: roman.id,

  document: %{
    version: "0.1",
    sequential: false,
    steps: [
      %{ name: "Get up" },
      %{ name: "Eat breakfast" },
      %{ name: "Have a shower" },
      %{ name: "Brush teeth" },
    ]
  }
})

Repo.insert!(%Checklists.Checklist{
  title: "Shopping list",
  description: "All you need for carbonara",
  access: :personal,
  user_id: roman.id,

  document: %{
    version: "0.1",
    sequential: false,
    steps: [
      %{ name: "Guanciale" },
      %{ name: "Pecorino romano" },
      %{ name: "Eggs" },
      %{ name: "Spaghetti" },
      %{ name: "Salt" },
      %{ name: "Pepper" },
    ]
  }
})

Repo.insert!(%Checklists.Checklist{
  title: "To do list",
  description: "Things to do",
  access: :public,
  user_id: aaron.id,

  document: %{
    version: "0.1",
    sequential: false,
    steps: [
      %{ name: "One thing" },
      %{ name: "That other thing" },
    ]
  }
})
