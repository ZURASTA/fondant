defmodule Fondant.Service.Repo.Migrations.Allergen do
    use Ecto.Migration
    import Translecto.Migration

    def change do
        create table(:allergen_name_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the name of the allergen"

            timestamps()
        end

        create table(:allergens) do
            add :ref, :string,
                null: false

            add :ref_id, :uuid,
                null: false

            translate :name, null: false

            timestamps()
        end

        create index(:allergens, [:ref], unique: true)
        create index(:allergens, [:ref_id], unique: true)
        create index(:allergens, [:name], unique: true)
    end
end
