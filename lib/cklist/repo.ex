defmodule Cklist.Repo do
  use Ecto.Repo,
    otp_app: :cklist,
    adapter: Ecto.Adapters.Postgres
end
