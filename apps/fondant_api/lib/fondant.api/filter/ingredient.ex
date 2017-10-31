defmodule Fondant.API.Filter.Ingredient do
    @moduledoc """
      Discover ingredient filters.
    """

    @service Fondant.Service.Filter
    @filter_type :ingredient

    alias Fondant.API.Filter

    @doc """
      Retrieve a specific ingredient filter for the given id.

      If no filter exists with the given id, it will return an error.

      Returns `{ :ok, ingredient_filter }` if the operation was successful, otherwise returns
      an error.
    """
    @spec get(integer, Filter.locale) :: { :ok, Fondant.Filter.Ingredient.t } | { :error, String.t }
    def get(id, locale) do
        GenServer.call(@service, { :get, { @filter_type, id, locale } })
    end

    @doc """
      Find all ingredient filters that match the given query.

      The query field accepts:

      * ':any' - Search all fields
      * `:name` - Search all ingredient names
      * `:type` - Search all ingredient types

      The options field accepts:

      * `:locale` - The localisation `t:Fondant.API.Filter.locale/0`
      to be applied for the search (see `Fondant.Service.Locale`).
      * `:page` - The pagination index to retrieve the results of.
      * `:limit` - The max number of entries to retrieve.

      Returns `{ :ok, { ingredient_filters, page } }` if the operation was successful, where
      `ingredient_filters` is the list of ingredient filters, and `page` is the next pagination
      index. Otherwise returns an error.
    """
    @spec find(keyword(String.t), keyword(any)) :: { :ok, { [Fondant.Filter.Ingredient.t], Filter.page } } | { :error, String.t }
    def find(query, options \\ []) do
        GenServer.call(@service, { :find, { @filter_type, query, options } })
    end

    @doc """
      Get the list of queryable parameters that can be used in ingredient filter queries.
    """
    @spec queryables() :: [atom]
    def queryables() do
        GenServer.call(@service, { :queryables, { @filter_type } })
    end
end
