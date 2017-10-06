defmodule Fondant.Service do
    @moduledoc """
      The service application for translating filters.
    """

    use Application

    @doc """
      Start the service application.

      By default the service will run in `:auto` setup mode, which
      will automatically create and migrate the database. To override
      this behaviour, the mode can be passed in as an argument for the
      `:setup_mode` key. The supported setup modes are: `:auto` and
      `:manual`. If using manual mode, the state of the database is
      left up to the caller.
    """
    def start(_type, args) do
        import Supervisor.Spec, warn: false

        setup_mode = args[:setup_mode] || :auto

        if setup_mode == :auto do
            if Mix.env == :test do
                Fondant.Service.Repo.DB.drop()
            end
            Fondant.Service.Repo.DB.create()
        end

        children = [
            Fondant.Service.Repo,
            Fondant.Service.Filter
        ]

        opts = [strategy: :one_for_one, name: Fondant.Service.Supervisor]
        supervisor = Supervisor.start_link(children, opts)

        if setup_mode == :auto do
            Fondant.Service.Repo.DB.migrate()
        end

        supervisor
    end
end
