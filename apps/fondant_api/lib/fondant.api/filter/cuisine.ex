defmodule Fondant.API.Filter.Cuisine do
    @moduledoc """
      Discover cuisine filters.
    """

    @service Fondant.Service.Filter
    @filter_type :cuisine

    alias Fondant.API.Filter

    @doc """
      Retrieve a specific cuisine filter for the given id.

      If no filter exists with the given id, it will return an error.

      Returns `{ :ok, cuisine_filter }` if the operation was successful, otherwise returns
      an error.
    """
    @spec get(integer, Filter.locale) :: { :ok, Fondant.Filter.Cuisine.t } | { :error, String.t }
    def get(id, locale) do
        GenServer.call(@service, { :get, { @filter_type, id, locale } })
    end

    @doc """
      Find all cuisine filters that match the given query.

      The query field accepts:

      * ':any' - Search all fields
      * `:name` - Search all cuisine names
      * `:region` - Search all cuisine regions by `[:id, :continent, :subregion, :country, :province]`

      The options field accepts:

      * `:locale` - The localisation `t:Fondant.Service.Filter.Type.locale/0`
      to be applied for the search (see `Fondant.Service.Locale`).
      * `:page` - The pagination index to retrieve the results of.
      * `:limit` - The max number of entries to retrieve.

      Returns `{ :ok, { cuisine_filters, page } }` if the operation was successful, where
      `cuisine_filters` is the list of cuisine filters, and `page` is the next pagination
      index. Otherwise returns an error.
    """
    @spec find(keyword(String.t), keyword(any)) :: { :ok, { [Fondant.Filter.Cuisine.t], Filter.page } } | { :error, String.t }
    def find(query, options \\ []) do
        GenServer.call(@service, { :find, { @filter_type, query, options } })
    end

    @doc """
      Get the list of queryable parameters that can be used in cuisine filter queries.
    """
    @spec queryables() :: [atom]
    def queryables() do
        GenServer.call(@service, { :queryables, { @filter_type } })
    end
end
