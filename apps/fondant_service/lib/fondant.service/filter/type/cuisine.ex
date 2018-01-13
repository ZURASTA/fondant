defmodule Fondant.Service.Filter.Type.Cuisine do
    @moduledoc """
      Support cuisine filters.
    """

    @behaviour Fondant.Service.Filter.Type

    alias Fondant.Service.Filter
    alias Fondant.Service.Filter.Type.Cuisine
    require Logger
    use Translecto.Query

    @impl Filter.Type
    def get(id, locale) do
        case Fondant.Service.Locale.to_locale_id(locale) do
            nil -> { :error, "Invalid locale" }
            locale ->
                query = from cuisine in Cuisine.Model,
                    where: cuisine.id == ^id,
                    locale: ^locale,
                    translate: name in cuisine.name,
                    join: region in Cuisine.Region.Model, where: region.id == cuisine.region_id,
                    translate: continent in region.continent,
                    translate: subregion in region.subregion,
                    translate: country in region.country,
                    translate: province in region.province,
                    select: %{
                        id: cuisine.id,
                        name: name.term,
                        region: %{
                            id: region.ref_id,
                            continent: continent.term,
                            subregion: subregion.term,
                            country: country.term,
                            province: province.term
                        }
                    }

                case Fondant.Service.Repo.one(query) do
                    nil -> { :error, "Cuisine does not exist" }
                    result -> { :ok, Map.merge(%Fondant.Filter.Cuisine{}, %{ result | region: Map.merge(%Fondant.Filter.Cuisine.Region{}, result.region) }) }
                end
        end
    end

    defp query_all([{ :any, any }|args], options) do
        any = LikeSanitizer.escape(any) <> "%"
        where(query_all(args, options), [i, cn, r, c, s, n, p],
            ilike(cn.term, ^any) or
            ilike(c.term, ^any) or
            ilike(s.term, ^any) or
            ilike(n.term, ^any) or
            ilike(p.term, ^any)
        )
    end
    defp query_all([{ :name, name }|args], options) do
        name = LikeSanitizer.escape(name) <> "%"
        where(query_all(args, options), [i, n, t], ilike(n.term, ^name))
    end
    defp query_all([{ :region, region }|args], options) do
        Enum.reduce(region, query_all(args, options), fn
            { :id, id }, query -> where(query, [i, cn, r, c, s, n, p], r.ref_id == ^id)
            { :continent, continent }, query -> where(query, [i, cn, r, c, s, n, p], ilike(c.term, ^(LikeSanitizer.escape(continent) <> "%")))
            { :subregion, subregion }, query -> where(query, [i, cn, r, c, s, n, p], ilike(s.term, ^(LikeSanitizer.escape(subregion) <> "%")))
            { :country, country }, query -> where(query, [i, cn, r, c, s, n, p], ilike(n.term, ^(LikeSanitizer.escape(country) <> "%")))
            { :province, province }, query -> where(query, [i, cn, r, c, s, n, p], ilike(p.term, ^(LikeSanitizer.escape(province) <> "%")))
        end)
    end
    defp query_all([], options) do
        from cuisine in Cuisine.Model,
            locales: ^options[:locale],
            translate: name in cuisine.name,
            join: region in Cuisine.Region.Model, where: region.id == cuisine.region_id,
            translate: continent in region.continent,
            translate: subregion in region.subregion,
            translate: country in region.country,
            translate: province in region.province,
            limit: ^options[:limit],
            where: cuisine.id > ^options[:page],
            locale_match: [name, continent, subregion, country, province],
            select: %{
                id: cuisine.id,
                name: name.term,
                region: %{
                    id: region.ref_id,
                    continent: continent.term,
                    subregion: subregion.term,
                    country: country.term,
                    province: province.term
                }
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
                            nil -> { :error, "Could not retrieve any cuisines" }
                            [] -> { :ok, { [], options[:page] } }
                            result -> { :ok, { Enum.map(result, &Map.merge(%Fondant.Filter.Cuisine{}, %{ &1 | region: Map.merge(%Fondant.Filter.Cuisine.Region{}, &1.region) })), List.last(result).id } }
                        end
                end
        end
    end

    @impl Filter.Type
    def queryables(), do: [:any, :name, :region]
end
