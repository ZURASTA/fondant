defmodule Fondant.API.Filter.Diet do
    @moduledoc """
      Discover dietary filters.
    """

    @service Fondant.Service.Filter
    @filter_type :diet

    alias Fondant.API.Filter

    @doc """
      Retrieve a specific diet filter for the given id.

      If no filter exists with the given id, it will return an error.

      #{Fondant.API.option_docs}

      Returns `{ :ok, diet_filter }` if the operation was successful, otherwise returns
      an error.
    """
    @spec get(Fondant.Filter.id, Filter.locale, keyword(any)) :: { :ok, Fondant.Filter.Diet.t } | { :error, String.t }
    def get(id, locale, options \\ []) do
        options = Fondant.API.defaults(options)
        GenServer.call(options[:server].(@service), { :get, { @filter_type, id, locale } }, options[:timeout])
    end

    @doc """
      Find all diet filters that match the given query.

      The query field accepts:

      * `:any` - Search all fields
      * `:name` - Search all diet names

      #{Fondant.API.option_docs}
      * `:locale` - The localisation `t:Fondant.API.Filter.locale/0`
      to be applied for the search (see `Fondant.Service.Locale`).
      * `:page` - The pagination index to retrieve the results of.
      * `:limit` - The max number of entries to retrieve.

      Returns `{ :ok, { diet_filters, page } }` if the operation was successful, where
      `diet_filters` is the list of diet filters, and `page` is the next pagination
      index. Otherwise returns an error.
    """
    @spec find(keyword(String.t), keyword(any)) :: { :ok, { [Fondant.Filter.Diet.t], Filter.page } } | { :error, String.t }
    def find(query, options \\ []) do
        options = Fondant.API.defaults(options)
        GenServer.call(options[:server].(@service), { :find, { @filter_type, query, options } }, options[:timeout])
    end

    @doc """
      Get the list of queryable parameters that can be used in diet filter queries.

      #{Fondant.API.option_docs}
    """
    @spec queryables(keyword(any)) :: [atom]
    def queryables(options \\ []) do
        options = Fondant.API.defaults(options)
        GenServer.call(options[:server].(@service), { :queryables, { @filter_type } }, options[:timeout])
    end
end
