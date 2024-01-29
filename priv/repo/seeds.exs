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

Cklist.Repo.insert!(%Cklist.Accounts.User{
  email: "audry@cklist.org",
  password: "romanholiday",
  hashed_password: Bcrypt.hash_pwd_salt("romanholiday"),
  confirmed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
})
