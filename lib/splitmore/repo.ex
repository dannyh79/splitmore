defmodule Splitmore.Repo do
  use Ecto.Repo,
    otp_app: :splitmore,
    adapter: Ecto.Adapters.Postgres
end
