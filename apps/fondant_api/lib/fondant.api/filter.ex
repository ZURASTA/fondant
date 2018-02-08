defmodule Fondant.API.Filter do
    @moduledoc """
      Manage the current filter dataset.
    """

    @type locale :: String.t
    @type page :: integer

    @service Fondant.Service.Filter

    @doc """
      Clean the database.

      Removes all filters and history of the dataset.
    """
    @spec clean() :: :ok | { :error, String.t }
    def clean() do
        GenServer.call(@service, { :db, :clean })
    end

    @doc """
      Rollback the database.

      Rollback the database to the previous version of the dataset.

      If successful returns `:ok` and the current timestamp.
    """
    @spec rollback() :: { :ok, integer } | { :error, String.t }
    def rollback() do
        GenServer.call(@service, { :db, :rollback })
    end

    @doc """
      Migrate the database.

      Migrates the database to the latest version of the dataset.

      If successful returns `:ok` and the current timestamp.
    """
    @spec migrate() :: { :ok, integer } | { :error, String.t }
    def migrate() do
        GenServer.call(@service, { :db, :migrate })
    end
end
