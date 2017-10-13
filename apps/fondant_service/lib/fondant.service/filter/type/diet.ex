defmodule Fondant.Service.Filter.Type.Diet do
    @moduledoc """
      Support diet filters.
    """

    @behaviour Fondant.Service.Filter.Type

    alias Fondant.Service.Filter
    alias Fondant.Service.Filter.Type.Diet
    require Logger
    use Translecto.Query

    @impl Filter.Type
    def get(id, locale) do
        query = from diet in Diet.Model,
            where: diet.id == ^id,
            locale: ^Fondant.Service.Locale.to_locale_id!(locale),
            translate: name in diet.name,
            select: %{
                id: diet.id,
                name: name.term
            }

        case Fondant.Service.Repo.one(query) do
            nil -> { :error, "Diet does not exist" }
            result -> { :ok, Map.merge(%Fondant.Filter.Diet{}, result) }
        end
    end

    defp query_all([{ :any, any }|args], options) do
        any = LikeSanitizer.escape(any) <> "%"
        where(query_all(args, options), [i, n], ilike(n.term, ^any))
    end
    defp query_all([{ :name, name }|args], options) do
        name = LikeSanitizer.escape(name) <> "%"
        where(query_all(args, options), [i, n], ilike(n.term, ^name))
    end
    defp query_all([], options) do
        from diet in Diet.Model,
            locales: ^Fondant.Service.Locale.to_locale_id_list!(options[:locale]),
            translate: name in diet.name,
            limit: ^options[:limit],
            where: diet.id > ^options[:page],
            select: %{
                id: diet.id,
                name: name.term
            }
    end

    @impl Filter.Type
    def find(query, options) do
        options = Keyword.merge([page: 0], options)
        case Fondant.Service.Repo.all(query_all(query, options)) do
            nil -> { :error, "Could not retrieve any diets" }
            [] -> { :ok, { [], options[:page] } }
            result -> { :ok, { Enum.map(result, &Map.merge(%Fondant.Filter.Diet{}, &1)), List.last(result).id } }
        end
    end

    @impl Filter.Type
    def queryables(), do: [:any, :name]
end
