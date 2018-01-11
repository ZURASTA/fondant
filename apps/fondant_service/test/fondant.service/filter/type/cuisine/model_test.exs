defmodule Fondant.Service.Filter.Type.Cuisine.ModelTest do
    use Fondant.Service.Case
    use Translecto.Query

    alias Fondant.Service.Filter.Type.Cuisine

    @valid_model %Cuisine.Model{ name: 1, region_id: 1 }

    test "empty" do
        refute_change(%Cuisine.Model{})
    end

    test "only name" do
        refute_change(%Cuisine.Model{}, %{ name: 1 })
    end

    test "only region" do
        refute_change(%Cuisine.Model{}, %{ region_id: 1 })
    end

    test "uniqueness" do
        en = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "en" })
        fr = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "fr" })
        en_continent = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Continent.Model.changeset(%Cuisine.Region.Translation.Continent.Model{}, %{ translate_id: 1, locale_id: en.id, term: "africa" }))
        _fr_continent = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Continent.Model.changeset(%Cuisine.Region.Translation.Continent.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "afrique" }))
        en_subregion = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Subregion.Model.changeset(%Cuisine.Region.Translation.Subregion.Model{}, %{ translate_id: 1, locale_id: en.id, term: "central africa" }))
        _fr_subregion = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Subregion.Model.changeset(%Cuisine.Region.Translation.Subregion.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "afrique centrale" }))
        en_country = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Country.Model.changeset(%Cuisine.Region.Translation.Country.Model{}, %{ translate_id: 1, locale_id: en.id, term: "gabon" }))
        _fr_country = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Country.Model.changeset(%Cuisine.Region.Translation.Country.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "gabon" }))
        en_province = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Province.Model.changeset(%Cuisine.Region.Translation.Province.Model{}, %{ translate_id: 1, locale_id: en.id, term: "estuaire" }))
        _fr_province = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Province.Model.changeset(%Cuisine.Region.Translation.Province.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "estuaire" }))

        region = Fondant.Service.Repo.insert!(Cuisine.Region.Model.changeset(%Cuisine.Region.Model{}, %{ ref: "estuaire", ref_id: Ecto.UUID.generate(), continent: en_continent.translate_id, subregion: en_subregion.translate_id, country: en_country.translate_id, province: en_province.translate_id }))
        region2 = Fondant.Service.Repo.insert!(Cuisine.Region.Model.changeset(%Cuisine.Region.Model{}, %{ ref: "africa", ref_id: Ecto.UUID.generate(), continent: en_continent.translate_id }))

        _cuisine = Fondant.Service.Repo.insert!(Cuisine.Model.changeset(@valid_model, %{ region_id: region.id }))

        assert_change(%Cuisine.Model{}, %{ name: @valid_model.name + 1, region_id: region2.id + 1 })
        |> assert_insert(:error)
        |> assert_error_value(:region, { "does not exist", [] })

        assert_change(%Cuisine.Model{}, %{ name: @valid_model.name, region_id: region.id })
        |> assert_insert(:error)
        |> assert_error_value(:name, { "has already been taken", [] })

        assert_change(%Cuisine.Model{}, %{ name: @valid_model.name, region_id: region2.id })
        |> assert_insert(:error)
        |> assert_error_value(:name, { "has already been taken", [] })

        assert_change(%Cuisine.Model{}, %{ name: @valid_model.name + 1, region_id: region.id })
        |> assert_insert(:ok)

        assert_change(%Cuisine.Model{}, %{ name: @valid_model.name + 2, region_id: region2.id })
        |> assert_insert(:ok)
    end

    test "translation" do
        en = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "en" })
        fr = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "fr" })
        en_continent = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Continent.Model.changeset(%Cuisine.Region.Translation.Continent.Model{}, %{ translate_id: 1, locale_id: en.id, term: "europe" }))
        _fr_continent = Fondant.Service.Repo.insert!(Cuisine.Region.Translation.Continent.Model.changeset(%Cuisine.Region.Translation.Continent.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "europe" }))

        region = Fondant.Service.Repo.insert!(Cuisine.Region.Model.changeset(%Cuisine.Region.Model{}, %{ ref: "europe", ref_id: Ecto.UUID.generate(), continent: en_continent.translate_id }))

        en_pasta = Fondant.Service.Repo.insert!(Cuisine.Translation.Name.Model.changeset(%Cuisine.Translation.Name.Model{}, %{ translate_id: 1, locale_id: en.id, term: "pasta" }))
        _fr_pasta = Fondant.Service.Repo.insert!(Cuisine.Translation.Name.Model.changeset(%Cuisine.Translation.Name.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "pâtes" }))

        _cuisine_pasta = Fondant.Service.Repo.insert!(Cuisine.Model.changeset(%Cuisine.Model{}, %{ name: en_pasta.translate_id, region_id: region.id }))

        query = from cuisine in Cuisine.Model,
            locale: ^en.id,
            translate: name in cuisine.name,
            join: region in Cuisine.Region.Model, where: region.id == cuisine.region_id,
            translate: continent in region.continent,
            select: { name.term, continent.term }

        assert Fondant.Service.Repo.all(query) == [{ "pasta", "europe" }]

        query = from cuisine in Cuisine.Model,
            locale: ^fr.id,
            translate: name in cuisine.name,
            join: region in Cuisine.Region.Model, where: region.id == cuisine.region_id,
            translate: continent in region.continent,
            select: { name.term, continent.term }

        assert Fondant.Service.Repo.all(query) == [{ "pâtes", "europe" }]

        query = from cuisine in Cuisine.Model,
            locale: ^fr.id,
            translate: name in cuisine.name, where: name.term == "pâtes",
            join: region in Cuisine.Region.Model, where: region.id == cuisine.region_id,
            translate: continent in region.continent,
            select: continent.term

        assert Fondant.Service.Repo.all(query) == ["europe"]
    end
end
