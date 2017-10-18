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
        query = from region in Region.Model,
            where: region.id == ^id,
            locale: ^Fondant.Service.Locale.to_locale_id!(locale),
            translate: continent in region.continent,
            translate: subregion in region.subregion,
            translate: country in region.country,
            translate: province in region.province,
            select: %{
                id: region.id,
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
            locales: ^Fondant.Service.Locale.to_locale_id_list!(options[:locale]),
            translate: continent in region.continent,
            translate: subregion in region.subregion,
            translate: country in region.country,
            translate: province in region.province,
            limit: ^options[:limit],
            where: region.id > ^options[:page],
            locale_match: [continent, subregion, country, province],
            select: %{
                id: region.id,
                continent: continent.term,
                subregion: subregion.term,
                country: country.term,
                province: province.term
            }
    end

    @impl Filter.Type
    def find(query, options) do
        options = Keyword.merge([page: 0], options)
        case Fondant.Service.Repo.all(query_all(query, options)) do
            nil -> { :error, "Could not retrieve any regions" }
            [] -> { :ok, { [], options[:page] } }
            result -> { :ok, { Enum.map(result, &Map.merge(%Fondant.Filter.Cuisine.Region{}, &1)), List.last(result).id } }
        end
    end

    @impl Filter.Type
    def queryables(), do: [:any, :continent, :subregion, :country, :province]
end
