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

    @doc """
      Implement the behaviour for retrieving a specific filter of type with
      the given id.

      If the filter does not exist it will return an error.

      If the operation was successful return `{ :ok, filter }`.
    """
    @callback get(id :: integer, locale) :: { :ok, filter :: struct() } | { :error, reason :: String.t }

    @doc """
      Implement the behaviour for finding filters that match the given query.

      If the operation was successful return `{ :ok, [filter] }`. Otherwise
      return the error.
    """
    @callback find(locale, query :: keyword(String.t), options :: keyword(String.t)) :: { :ok, filters :: [struct()] } | { :error, reason :: String.t }

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
    @spec get(atom, integer, locale) :: { :ok, struct() } | { :error, String.t }
    def get(type, id, locale) do
        atom_to_module(type).get(id, locale)
    end

    @doc """
      Find all filters of type that match the given query.

      Returns `{ :ok, [filter] }` if the operation was successful, otherwise
      returns an error.
    """
    @spec find(atom, locale, keyword(String.t), keyword(String.t)) :: { :ok, struct() } | { :error, String.t }
    def find(type, locale, query, options \\ []) do
        atom_to_module(type).find(locale, query, options)
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
