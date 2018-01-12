defmodule Fondant.Service.Filter.Type.Cuisine.Region do
    @moduledoc """
      Support cuisie region filters.
    """

    @behaviour Fondant.Service.Filter.Type

    alias Fondant.Service.Filter
    alias Fondant.Service.Filter.Type.Cuisine.Region
    require Logger
    use Translecto.Query

    @impl Filter.Type
    def get(id, locale) do
        case Fondant.Service.Locale.to_locale_id(locale) do
            nil -> { :error, "Invalid locale" }
            locale ->
                query = from region in Region.Model,
                    where: region.ref_id == ^id,
                    locale: ^locale,
                    translate: continent in region.continent,
                    translate: subregion in region.subregion,
                    translate: country in region.country,
                    translate: province in region.province,
                    select: %{
                        id: region.ref_id,
                        continent: continent.term,
                        subregion: subregion.term,
                        country: country.term,
                        province: province.term
                    }

                case Fondant.Service.Repo.one(query) do
                    nil -> { :error, "Region does not exist" }
                    result -> { :ok, Map.merge(%Fondant.Filter.Cuisine.Region{}, result) }
                end
        end
    end

    defp query_all([{ :any, any }|args], options) do
        any = LikeSanitizer.escape(any) <> "%"
        where(query_all(args, options), [i, c, s, n, p],
            ilike(c.term, ^any) or
            ilike(s.term, ^any) or
            ilike(n.term, ^any) or
            ilike(p.term, ^any)
        )
    end
    defp query_all([{ :continent, continent }|args], options) do
        continent = LikeSanitizer.escape(continent) <> "%"
        where(query_all(args, options), [i, c, s, n, p], ilike(c.term, ^continent))
    end
    defp query_all([{ :subregion, subregion }|args], options) do
        subregion = LikeSanitizer.escape(subregion) <> "%"
        where(query_all(args, options), [i, c, s, n, p], ilike(s.term, ^subregion))
    end
    defp query_all([{ :country, country }|args], options) do
        country = LikeSanitizer.escape(country) <> "%"
        where(query_all(args, options), [i, c, s, n, p], ilike(n.term, ^country))
    end
    defp query_all([{ :province, province }|args], options) do
        province = LikeSanitizer.escape(province) <> "%"
        where(query_all(args, options), [i, c, s, n, p], ilike(p.term, ^province))
    end
    defp query_all([], options) do
        from region in Region.Model,
            locales: ^options[:locale],
            translate: continent in region.continent,
            translate: subregion in region.subregion,
            translate: country in region.country,
            translate: province in region.province,
            limit: ^options[:limit],
            where: region.id > ^options[:page],
            locale_match: [continent, subregion, country, province],
            select: %{
                id: region.ref_id,
                continent: continent.term,
                subregion: subregion.term,
                country: country.term,
                province: province.term,
                page: region.id
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
                            nil -> { :error, "Could not retrieve any regions" }
                            [] -> { :ok, { [], options[:page] } }
                            result -> { :ok, { Enum.map(result, &Map.merge(%Fondant.Filter.Cuisine.Region{}, Map.delete(&1, :page))), List.last(result).page } }
                        end
                end
        end
    end

    @impl Filter.Type
    def queryables(), do: [:any, :continent, :subregion, :country, :province]
end
