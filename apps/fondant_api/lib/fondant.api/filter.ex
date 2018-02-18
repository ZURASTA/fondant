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

      #{Fondant.API.option_docs}

      If successful returns `:ok`. Otherwise returns an error.
    """
    @spec clean(keyword(any)) :: :ok | { :error, String.t }
    def clean(options \\ []) do
        options = Fondant.API.defaults(options)
        GenServer.call(options[:server].(@service), { :db, :clean }, options[:timeout])
    end

    @doc """
      Rollback the database.

      Rollback the database to the previous version of the dataset.

      #{Fondant.API.option_docs}

      If successful returns `:ok` and the current timestamp. Otherwise returns
      an error.
    """
    @spec rollback(keyword(any)) :: { :ok, integer } | { :error, String.t }
    def rollback(options \\ []) do
        options = Fondant.API.defaults(options)
        GenServer.call(options[:server].(@service), { :db, :rollback }, options[:timeout])
    end

    @doc """
      Migrate the database.

      Migrates the database to the latest version of the dataset.

      #{Fondant.API.option_docs}

      If successful returns `:ok` and the current timestamp. Otherwise returns
      an error.
    """
    @spec migrate(keyword(any)) :: { :ok, integer } | { :error, String.t }
    def migrate(options \\ []) do
        options = Fondant.API.defaults(options)
        GenServer.call(options[:server].(@service), { :db, :migrate }, options[:timeout])
    end

    @doc """
      Get a paginated list of migration timestamps.

      #{Fondant.API.option_docs}
      * `:page` - The pagination index to retrieve the results of.
      * `:limit` - The max number of entries to retrieve.

      If successful returns `:ok` and the list of timestamps for the current
      page, and index to the next page.

      Returns `{ :ok, { timestamps, page } }` if the operation was successful, where
      `timestamps` is the list of `integer`, and `page` is the next pagination
      index. Otherwise returns an error.
    """
    @spec migrations(keyword()) :: { :ok, { [integer], page } } | { :error, String.t }
    def migrations(options \\ []) do
        options = Fondant.API.defaults(options)
        GenServer.call(options[:server].(@service), { :db, :migrations, { options } }, options[:timeout])
    end
end
