defmodule Fondant.Service.Filter.Type do
    @moduledoc """
      Manages the interactions with filter types.

      Filter types will implement the given callbacks to expose the given filter.

      ##Implementing a filter type

      Filter types should be implemented in a module conforming to
      `#{String.slice(to_string(__MODULE__), 7..-1)}.type`. Where type is the capitalized
      filter type.

      e.g. For a filter type that should be identified using the :diet atom, then the
      implementation for that communication method should fall under
      `#{String.slice(to_string(__MODULE__), 7..-1)}.Diet`.
    """

    @type locale :: String.t
    @type page :: integer
    @type filter :: struct()

    @doc """
      Implement the behaviour for retrieving a specific filter of type with
      the given id.

      If the filter does not exist it will return an error.

      If the operation was successful return `{ :ok, filter }`.
    """
    @callback get(id :: String.t, locale) :: { :ok, filter } | { :error, reason :: String.t }

    @doc """
      Implement the behaviour for finding filters that match the given query.

      Common behaviour is to support an all inclusive search (`:any`), and specific
      query options for each searchable field.

      Options may be provided to customise the operation. Required options that
      must be supported are:

      * `:locale` - The localisation `t:Fondant.Service.Filter.Type.locale/0`
      to be applied for the search (see `Fondant.Service.Locale`).
      * `:page` - The pagination index to retrieve the results of.
      * `:limit` - The max number of entries to retrieve.

      If the operation was successful return `{ :ok, { filters, page } }`, where
      `filters` is the list of filters, and `page` is the next pagination index.
      Otherwise return the error.
    """
    @callback find(query :: keyword(String.t), options :: keyword(any)) :: { :ok, { [filter], page } } | { :error, reason :: String.t }

    @doc """
      Implement the behaviour for returning a list of the queryable parameters.
    """
    @callback queryables() :: [atom]

    @doc """
      Retrieve a specific filter of type for the given id.

      If no filter exists with the given id, it will return an error.

      Returns `{ :ok, filter }` if the operation was successful, otherwise returns
      an error.
    """
    @spec get(atom, String.t, locale) :: { :ok, filter } | { :error, String.t }
    def get(type, id, locale) do
        atom_to_module(type).get(id, locale)
    end

    @doc """
      Find all filters of type that match the given query.

      The query field accepts any fields returned by
      `Fondant.Service.Filter.Type.queryables/1`. For more detail on the specific
      fields, see the type's implementation.

      The options field can specify the `:locale`, `:page`, and `:limit`. Other
      fields may also be supported, to find details on them see the type's
      implementation.

      * `:locale` - The localisation `t:Fondant.Service.Filter.Type.locale/0`
      to be applied for the search (see `Fondant.Service.Locale`).
      * `:page` - The pagination index to retrieve the results of.
      * `:limit` - The max number of entries to retrieve.

      Returns `{ :ok, { filters, page } }` if the operation was successful, where
      `filters` is the list of filters, and `page` is the next pagination index.
      Otherwise returns an error.
    """
    @spec find(atom, keyword(String.t), keyword(any)) :: { :ok, { [filter], page } } | { :error, String.t }
    def find(type, query, options \\ []) do
        atom_to_module(type).find(query, options)
    end

    @doc """
      Get the list of queryable parameters that can be applied to the given filter
      type.
    """
    @spec queryables(atom) :: [atom]
    def queryables(type) do
        atom_to_module(type).queryables()
    end

    @spec atom_to_module(atom) :: atom
    defp atom_to_module(name) do
        String.to_atom(to_string(__MODULE__) <> "." <> format_as_module(to_string(name)))
    end

    @spec format_as_module(String.t) :: String.t
    defp format_as_module(name) do
        name
        |> String.split(".")
        |> Enum.map(fn module ->
            String.split(module, "_") |> Enum.map(&String.capitalize(&1)) |> Enum.join
        end)
        |> Enum.join(".")
    end
end
