defmodule Fondant.Service.Repo.Migrations.Cuisine do
    use Ecto.Migration
    import Translecto.Migration

    def change do
        create table(:cuisine_name_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the cuisine's name"

            timestamps()
        end

        create table(:cuisines) do
            add :ref, :string,
                null: false

            add :ref_id, :uuid,
                null: false

            translate :name, null: false

            add :region_id, references(:cuisine_regions),
                null: false

            timestamps()
        end

        create index(:cuisines, [:ref], unique: true)
        create index(:cuisines, [:ref_id], unique: true)
        create index(:cuisines, [:name], unique: true)
    end
end
