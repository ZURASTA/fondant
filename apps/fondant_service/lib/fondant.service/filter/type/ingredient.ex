defmodule Fondant.Service.Filter.Type.Ingredient do
    @moduledoc """
      Support ingredient filters.
    """

    @behaviour Fondant.Service.Filter.Type

    alias Fondant.Service.Filter
    alias Fondant.Service.Filter.Type.Ingredient
    require Logger
    use Translecto.Query

    @impl Filter.Type
    def get(id, locale) do
        query = from ingredient in Ingredient.Model,
            where: ingredient.id == ^id,
            locale: ^Fondant.Service.Locale.to_locale_id!(locale),
            translate: name in ingredient.name,
            translate: type in ingredient.type,
            select: %{
                id: ingredient.id,
                name: name.term,
                type: type.term
            }

        case Fondant.Service.Repo.one(query) do
            nil -> { :error, "Ingredient does not exist" }
            result -> { :ok, Map.merge(%Fondant.Filter.Ingredient{}, result) }
        end
    end

    defp query_all([{ :any, any }|args], options) do
        any = LikeSanitizer.escape(any) <> "%"
        where(query_all(args, options), [i, n, t],
            ilike(n.term, ^any) or
            ilike(t.term, ^any)
        )
    end
    defp query_all([{ :name, name }|args], options) do
        name = LikeSanitizer.escape(name) <> "%"
        where(query_all(args, options), [i, n, t], ilike(n.term, ^name))
    end
    defp query_all([{ :type, type }|args], options) do
        type = LikeSanitizer.escape(type) <> "%"
        where(query_all(args, options), [i, n, t], ilike(t.term, ^type))
    end
    defp query_all([], options) do
        from ingredient in Fondant.Service.Filter.Type.Ingredient.Model,
            locales: ^Fondant.Service.Locale.to_locale_id_list!(options[:locale]),
            translate: name in ingredient.name,
            translate: type in ingredient.type,
            limit: ^options[:limit],
            where: ingredient.id > ^options[:page],
            where: name.locale_id == type.locale_id,
            select: %{
                id: ingredient.id,
                name: name.term,
                type: type.term
            }
    end

    @impl Filter.Type
    def find(query, options) do
        options = Keyword.merge([page: 0], options)
        case Fondant.Service.Repo.all(query_all(query, options)) do
            nil -> { :error, "Could not retrieve any ingredients" }
            [] -> { :ok, { [], options[:page] } }
            result -> { :ok, { Enum.map(result, &Map.merge(%Fondant.Filter.Ingredient{}, &1)), List.last(result).id } }
        end
    end

    @impl Filter.Type
    def queryables(), do: [:any, :name, :type]
end
