defmodule Bonbon.Model.Cuisine.RegionTest do
    use Fondant.Service.Case
    use Translecto.Query

    alias Fondant.Service.Filter.Type.Cuisine.Region

    @valid_model %Region.Model{ ref: "test", ref_id: Ecto.UUID.generate(), continent: 1 }

    test "empty" do
        refute_change(%Region.Model{})
    end

    test "only ref" do
        refute_change(%Region.Model{}, %{ ref: "test" })
    end

    test "only ref_id" do
        refute_change(%Region.Model{}, %{ ref_id: Ecto.UUID.generate() })
    end

    test "only continent" do
        refute_change(%Region.Model{}, %{ continent: 1 })
    end

    test "only subregion" do
        refute_change(%Region.Model{}, %{ subregion: 1 })
    end

    test "only country" do
        refute_change(%Region.Model{}, %{ country: 1 })
    end

    test "only province" do
        refute_change(%Region.Model{}, %{ province: 1 })
    end

    test "without ref" do
        refute_change(%Region.Model{}, %{ ref_id: Ecto.UUID.generate(), continent: 1, subregion: 1, country: 1, province: 1 })
    end

    test "without ref_id" do
        refute_change(%Region.Model{}, %{ ref: "test", continent: 1, subregion: 1, country: 1, province: 1 })
    end

    test "without continent" do
        refute_change(%Region.Model{}, %{ ref: "test", ref_id: Ecto.UUID.generate(), subregion: 1, country: 1, province: 1 })
    end

    test "without subregion" do
        assert_change(%Region.Model{}, %{ ref: "test", ref_id: Ecto.UUID.generate(), continent: 1, country: 1, province: 1 })
    end

    test "without country" do
        assert_change(%Region.Model{}, %{ ref: "test", ref_id: Ecto.UUID.generate(), continent: 1, subregion: 1, province: 1 })
    end

    test "without province" do
        assert_change(%Region.Model{}, %{ ref: "test", ref_id: Ecto.UUID.generate(), continent: 1, subregion: 1, country: 1 })
    end

    test "uniqueness" do
        _name = Fondant.Service.Repo.insert!(@valid_model)

        assert_change(%Region.Model{}, %{ ref: @valid_model.ref, ref_id: Ecto.UUID.generate(), continent: @valid_model.continent + 1, subregion: @valid_model.subregion, country: @valid_model.country, province: @valid_model.province })
        |> assert_insert(:error)
        |> assert_error_value(:ref, { "has already been taken", [] })

        assert_change(%Region.Model{}, %{ ref: @valid_model.ref <> "1", ref_id: @valid_model.ref_id, continent: @valid_model.continent + 1, subregion: @valid_model.subregion, country: @valid_model.country, province: @valid_model.province })
        |> assert_insert(:error)
        |> assert_error_value(:ref_id, { "has already been taken", [] })

        assert_change(%Region.Model{}, %{ ref: @valid_model.ref <> "1", ref_id: Ecto.UUID.generate(), continent: @valid_model.continent, subregion: @valid_model.subregion, country: @valid_model.country, province: @valid_model.province })
        |> assert_insert(:error)
        |> assert_error_value(:region, { "has already been taken", [] })

        for continent <- (@valid_model.continent + 1)..2,
            subregion <- [nil, 1],
            country <- [nil, 1],
            province <- [nil, 1] do
                assert_change(%Region.Model{}, %{ ref: @valid_model.ref <> "1#{continent || 0}#{subregion || 0}#{country || 0}#{province || 0}", ref_id: Ecto.UUID.generate(), continent: continent, subregion: subregion, country: country, province: province })
                |> assert_insert(:ok)
        end

        for continent <- (@valid_model.continent + 1)..2,
            subregion <- [nil, 1],
            country <- [nil, 1],
            province <- [nil, 1] do
                assert_change(%Region.Model{}, %{ ref: @valid_model.ref <> "2#{continent || 0}#{subregion || 0}#{country || 0}#{province || 0}", ref_id: Ecto.UUID.generate(), continent: continent, subregion: subregion, country: country, province: province })
                |> assert_insert(:error)
                |> assert_error_value(:region, { "has already been taken", [] })
        end
    end

    test "translation" do
        en = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "en" })
        fr = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "fr" })
        en_continent = Fondant.Service.Repo.insert!(Region.Translation.Continent.Model.changeset(%Region.Translation.Continent.Model{}, %{ translate_id: 1, locale_id: en.id, term: "africa" }))
        _fr_continent = Fondant.Service.Repo.insert!(Region.Translation.Continent.Model.changeset(%Region.Translation.Continent.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "afrique" }))
        en_subregion = Fondant.Service.Repo.insert!(Region.Translation.Subregion.Model.changeset(%Region.Translation.Subregion.Model{}, %{ translate_id: 1, locale_id: en.id, term: "central africa" }))
        _fr_subregion = Fondant.Service.Repo.insert!(Region.Translation.Subregion.Model.changeset(%Region.Translation.Subregion.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "afrique centrale" }))
        en_country = Fondant.Service.Repo.insert!(Region.Translation.Country.Model.changeset(%Region.Translation.Country.Model{}, %{ translate_id: 1, locale_id: en.id, term: "gabon" }))
        _fr_country = Fondant.Service.Repo.insert!(Region.Translation.Country.Model.changeset(%Region.Translation.Country.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "gabon" }))
        en_province = Fondant.Service.Repo.insert!(Region.Translation.Province.Model.changeset(%Region.Translation.Province.Model{}, %{ translate_id: 1, locale_id: en.id, term: "estuaire" }))
        _fr_province = Fondant.Service.Repo.insert!(Region.Translation.Province.Model.changeset(%Region.Translation.Province.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "estuaire" }))

        _region = Fondant.Service.Repo.insert!(Region.Model.changeset(%Region.Model{}, %{ ref: "estuaire", ref_id: Ecto.UUID.generate(), continent: en_continent.translate_id, subregion: en_subregion.translate_id, country: en_country.translate_id, province: en_province.translate_id }))

        query = from region in Region.Model,
            locale: ^en.id,
            translate: continent in region.continent,
            translate: subregion in region.subregion,
            translate: country in region.country,
            translate: province in region.province,
            select: { continent.term, subregion.term, country.term, province.term }

        assert Fondant.Service.Repo.all(query) == [{ "africa", "central africa", "gabon", "estuaire" }]

        query = from region in Region.Model,
            locale: ^fr.id,
            translate: continent in region.continent,
            translate: subregion in region.subregion,
            translate: country in region.country,
            translate: province in region.province,
            select: { continent.term, subregion.term, country.term, province.term }

        assert Fondant.Service.Repo.all(query) == [{ "afrique", "afrique centrale", "gabon", "estuaire" }]

        query = from region in Region.Model,
            locale: ^fr.id,
            translate: country in region.country, where: country.term == "gabon",
            translate: continent in region.continent,
            select: continent.term

        assert Fondant.Service.Repo.all(query) == ["afrique"]
    end
end
