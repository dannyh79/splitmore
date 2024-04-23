# Splitmore

## Backlog

### Features

- [ ] Gmail OAuth

### E2E Tests

- [ ] Integrate playwright tests into `mix test`
- [ ] Support browsers other than chromium in e2e tests (`projects` in playwright.config.ts)
- [ ] Parallelize playwright tests (`workers` in playwright.config.ts)

## Development

### Prerequisite

 - [Elixir](https://elixir-lang.org/), recommanded to install via [asdf-vm](https://asdf-vm.com/)
 - local postgres database

### Setup for development

```bash
git clone https://github.com/dannyh79/splitmore.git
cd splitmore
cp config/dev.exs.example config/dev.exs
vim config/dev.exs # fill client creds under ueberauth
mix setup # will run deps.get, db init and assets preparation
```

### Start web development server

```bash
iex -S mix phx.server
# or without iex:
mix phx.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Run tests

```bash
mix test
```

#### Run E2E tests

```bash
mix e2e.setup # if first time
mix e2e.test
```

## Learn more about Phoenix web framework

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
    * Deployment guides: https://hexdocs.pm/phoenix/deployment.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
