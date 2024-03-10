# ✔️ cklist

Awesome :heavy_check_mark: checklists are about to come here. Stay tuned...

## 🤝 Contributing

We are just getting started. Feel free to reach out if you feel like joining.

### Setup notes

#### Framework

cklists are based on the awesome [Phoenix Framework](https://www.phoenixframework.org/).

#### Versions

Elixir, Erlang, and npm versions are managed with [asdf](https://asdf-vm.com/) in [.tool-versions](.tool-versions).

#### Database

We use [PostgreSQL](https://www.postgresql.org/) as database backend. Phoenix' authentication system makes use of the `citext` extension of PostgreSQL. If DB migration complains about missing the `citext` extension, try search for and installing the `postgres-contrib` package.

Database secrets can be stored in `.env`-style configuration. This is useful for both, local development and deployments. To override the database configuration, put the following contents

```none
DATABASE_URL="ecto://cklist:cklist@localhost/cklist_dev"
TEST_DATABASE_URL="ecto://cklist:cklist@localhost/cklist_test"
```

in a file `envs/.env` and adapt the defaults to your liking.
