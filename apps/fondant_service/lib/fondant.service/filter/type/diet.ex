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
        case Fondant.Service.Locale.to_locale_id(locale) do
            nil -> { :error, "Invalid locale" }
            locale ->
                query = from diet in Diet.Model,
                    where: diet.ref_id == ^id,
                    locale: ^locale,
                    translate: name in diet.name,
                    select: %{
                        id: diet.ref_id,
                        name: name.term
                    }

                case Fondant.Service.Repo.one(query) do
                    nil -> { :error, "Diet does not exist" }
                    result -> { :ok, Map.merge(%Fondant.Filter.Diet{}, result) }
                end
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
            locales: ^options[:locale],
            translate: name in diet.name,
            limit: ^options[:limit],
            where: diet.id > ^options[:page],
            select: %{
                id: diet.ref_id,
                name: name.term,
                page: diet.id
            }
    end

    @impl Filter.Type
    def find(query, options) do
        case Keyword.pop(options, :locale) do
            { nil, _ } -> { :error, "No locale provided" }
            { locale, options } ->
                case Fondant.Service.Locale.to_locale_id_list(locale) do
                    [] -> { :error, "Invalid locale" }
                    locale ->
                        options = Keyword.merge([page: 0], [{ :locale, locale }|options])
                        case Fondant.Service.Repo.all(query_all(query, options)) do
                            nil -> { :error, "Could not retrieve any diets" }
                            [] -> { :ok, { [], options[:page] } }
                            result -> { :ok, { Enum.map(result, &Map.merge(%Fondant.Filter.Diet{}, Map.delete(&1, :page))), List.last(result).page } }
                        end
                end
        end
    end

    @impl Filter.Type
    def queryables(), do: [:any, :name]
end
