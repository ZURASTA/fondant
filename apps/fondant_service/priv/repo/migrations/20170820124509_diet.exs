defmodule Fondant.Service.Repo.Migrations.Diet do
    use Ecto.Migration
    import Translecto.Migration

    def change do
        create table(:diet_name_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the name of the diet"

            timestamps()
        end

        create table(:diets) do
            add :ref, :string,
                null: false

            add :ref_id, :uuid,
                null: false

            translate :name, null: false

            timestamps()
        end

        create index(:diets, [:ref], unique: true)
        create index(:diets, [:ref_id], unique: true)
        create index(:diets, [:name], unique: true)
    end
end
