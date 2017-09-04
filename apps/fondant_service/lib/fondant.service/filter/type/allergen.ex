defmodule Fondant.Service.Filter.Type.Allergen do
    @moduledoc """
      Support allergen filters.
    """

    @behaviour Fondant.Service.Filter.Type

    alias Fondant.Service.Filter
    alias Fondant.Service.Filter.Type.Allergen
    require Logger
    use Translecto.Query

    @impl Filter.Type
    def get(id, locale) do
        query = from allergen in Allergen.Model,
            where: allergen.id == ^id,
            locales: ^Fondant.Service.Locale.to_locale_id_list!(locale),
            translate: name in allergen.name,
            select: %{
                id: allergen.id,
                name: name.term
            }

        case Fondant.Service.Repo.one(query) do
            nil -> { :error, "Allergen does not exist" }
            result -> { :ok, Map.merge(%Fondant.Filter.Allergen{}, result) }
        end
    end

    defp query_all([{ :any, any }|args], options) do
        any = any <> "%"
        where(query_all(args, options), [i, n], ilike(n.term, ^any))
    end
    defp query_all([{ :name, name }|args], options) do
        name = name <> "%"
        where(query_all(args, options), [i, n], ilike(n.term, ^name))
    end
    defp query_all([], options) do
        from allergen in Fondant.Service.Filter.Type.Allergen.Model,
            locales: ^Fondant.Service.Locale.to_locale_id_list!(options[:locale]),
            translate: name in allergen.name,
            limit: ^options[:limit],
            where: allergen.id > ^options[:page],
            select: %{
                id: allergen.id,
                name: name.term
            }
    end

    @impl Filter.Type
    def find(query, options) do
        case Fondant.Service.Repo.all(query_all(query, Keyword.merge([page: 0], options))) do
            nil -> { :error, "Could not retrieve any allergens" }
            [] -> { :ok, { [], 0 } }
            result -> { :ok, { Enum.map(result, &Map.merge(%Fondant.Filter.Allergen{}, &1)), List.last(result).id } }
        end
    end
end
