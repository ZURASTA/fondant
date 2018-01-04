defmodule Fondant.Service.Filter.Type.Allergen.ModelTest do
    use Fondant.Service.Case
    use Translecto.Query

    alias Fondant.Service.Filter.Type.Allergen

    @valid_model %Allergen.Model{ ref: "test", ref_id: Ecto.UUID.generate(), name: 1 }

    test "empty" do
        refute_change(%Allergen.Model{})
    end

    test "only ref" do
        refute_change(%Allergen.Model{}, %{ ref: "test" })
    end

    test "only ref_id" do
        refute_change(%Allergen.Model{}, %{ ref_id: Ecto.UUID.generate() })
    end

    test "only name" do
        refute_change(%Allergen.Model{}, %{ name: 1 })
    end

    test "without ref" do
        refute_change(%Allergen.Model{}, %{ ref_id: Ecto.UUID.generate(), name: 1 })
    end

    test "without ref_id" do
        refute_change(%Allergen.Model{}, %{ ref: "test", name: 1 })
    end

    test "without name" do
        refute_change(%Allergen.Model{}, %{ ref: "test", ref_id: Ecto.UUID.generate() })
    end

    test "uniqueness" do
        name = Fondant.Service.Repo.insert!(@valid_model)

        assert_change(%Allergen.Model{}, %{ ref: @valid_model.ref, ref_id: Ecto.UUID.generate(), name: @valid_model.name + 1 })
        |> assert_insert(:error)
        |> assert_error_value(:ref, { "has already been taken", [] })

        assert_change(%Allergen.Model{}, %{ ref: @valid_model.ref <> "1", ref_id: @valid_model.ref_id, name: @valid_model.name + 1 })
        |> assert_insert(:error)
        |> assert_error_value(:ref_id, { "has already been taken", [] })

        assert_change(%Allergen.Model{}, %{ ref: @valid_model.ref <> "1", ref_id: Ecto.UUID.generate(), name: @valid_model.name })
        |> assert_insert(:error)
        |> assert_error_value(:name, { "has already been taken", [] })

        assert_change(%Allergen.Model{}, %{ ref: @valid_model.ref <> "1", ref_id: Ecto.UUID.generate(), name: @valid_model.name + 1 })
        |> assert_insert(:ok)
    end

    test "translation" do
        en = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "en" })
        fr = Fondant.Service.Repo.insert!(%Fondant.Service.Locale.Model{ language: "fr" })
        en_peanut = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 1, locale_id: en.id, term: "peanut allergy" }))
        fr_peanut = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 1, locale_id: fr.id, term: "allergie à l'arachide" }))
        en_fish = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 2, locale_id: en.id, term: "fish allergy" }))
        fr_fish = Fondant.Service.Repo.insert!(Allergen.Translation.Name.Model.changeset(%Allergen.Translation.Name.Model{}, %{ translate_id: 2, locale_id: fr.id, term: "allergie au poisson" }))

        allergen_peanut = Fondant.Service.Repo.insert!(Allergen.Model.changeset(%Allergen.Model{}, %{ ref: "peanut", ref_id: Ecto.UUID.generate(), name: en_peanut.translate_id }))
        allergen_fish = Fondant.Service.Repo.insert!(Allergen.Model.changeset(%Allergen.Model{}, %{ ref: "fish", ref_id: Ecto.UUID.generate(), name: en_fish.translate_id }))

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
