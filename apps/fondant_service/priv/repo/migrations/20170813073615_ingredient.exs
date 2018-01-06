defmodule Fondant.Service.Repo.Migrations.Ingredient do
    use Ecto.Migration
    import Translecto.Migration

    def change do
        create table(:ingredient_type_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the ingredient's type"

            timestamps()
        end

        create table(:ingredient_name_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the ingredient's name"

            timestamps()
        end

        create table(:ingredients) do
            add :ref, :string,
                null: false

            add :ref_id, :uuid,
                null: false

            translate :type, null: true

            translate :name, null: false

            timestamps()
        end

        create index(:ingredients, [:ref], unique: true)
        create index(:ingredients, [:ref_id], unique: true)
        create index(:ingredients, [:name], unique: true)
    end
end
