defmodule {app}.Adapters.Repository.Repo do
  use Ecto.Repo,
  otp_app: :{app_snake},
  adapter: Ecto.Adapters.Postgres
end
