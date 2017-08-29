defmodule Fondant.Service.Filter.Type.Allergen.ModelTest do
    use Fondant.Service.Case
    use Translecto.Query

    alias Fondant.Service.Filter.Type.Allergen

    @valid_model %Allergen.Model{ name: 1 }

    test "empty" do
        refute_change(%Allergen.Model{})
    end

    test "only name" do
        assert_change(%Allergen.Model{}, %{ name: 1 })
    end

    test "uniqueness" do
        name = Fondant.Service.Repo.insert!(@valid_model)

        assert_change(%Allergen.Model{}, %{ name: @valid_model.name })
        |> assert_insert(:error)
        |> assert_error_value(:name, { "has already been taken", [] })

        assert_change(%Allergen.Model{}, %{ name: @valid_model.name + 1 })
        |> assert_insert(:ok)
    end

    test "translation" do
        en = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "en" })
        fr = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "fr" })
        en_peanut = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 1, locale_id: en.id, term: "peanut allergy" }))
        fr_peanut = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "allergie à l'arachide" }))
        en_fish = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 2, locale_id: en.id, term: "fish allergy" }))
        fr_fish = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 2, locale_id: fr.id, term: "allergie au poisson" }))

        allergen_peanut = Fondant.Service.Repo.insert!(Allergen.Model.changeset(%Allergen.Model{}, %{ name: en_peanut.translate_id }))
        allergen_fish = Fondant.Service.Repo.insert!(Allergen.Model.changeset(%Allergen.Model{}, %{ name: en_fish.translate_id }))

        query = from allergen in Allergen.Model,
            locale: ^en.id,
            translate: name in allergen.name,
            select: name.term

        assert Fondant.Service.Repo.all(query) == ["peanut allergy", "fish allergy"]

        query = from allergen in Allergen.Model,
            locale: ^fr.id,
            translate: name in allergen.name,
            select: name.term

        assert Fondant.Service.Repo.all(query) == ["allergie à l'arachide", "allergie au poisson"]

        query = from allergen in Allergen.Model,
            locale: ^fr.id,
            translate: name in allergen.name, where: name.term == "allergie au poisson",
            select: name.term

        assert Fondant.Service.Repo.all(query) == ["allergie au poisson"]
    end
end
