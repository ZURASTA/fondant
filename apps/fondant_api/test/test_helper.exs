Application.ensure_all_started(:fondant_service)
Application.ensure_all_started(:ecto)

ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Fondant.Service.Repo, :manual)
