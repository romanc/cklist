# cklist

Awesome checklists are about to come here. Stay tuned.

## Contributing

Contributions are welcome.

- cklists are based on the awesome [Phoenix Framework](https://www.phoenixframework.org/).
- Elixir & Erlang versions are managed with [asdf](https://asdf-vm.com/) in [.tool-versions](.tool-versions).
- We use [PostgreSQL](https://www.postgresql.org/) as database backend. For local development, we assume a user `cklist` exists (see [config/dev.exs](./config/dev.exs)). The authentication system makes use of the `citext` extension of PostgreSQL. If DB migration complains about missing the `citext` extension, try search for and installing the `postgres-contrib` package.
