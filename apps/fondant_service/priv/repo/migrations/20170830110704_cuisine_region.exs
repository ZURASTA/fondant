defmodule Fondant.Service.Repo.Migrations.CuisineRegion do
    use Ecto.Migration
    import Translecto.Migration

    def change do
        create table(:cuisine_region_continent_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the continent's name"

            timestamps()
        end

        create table(:cuisine_region_subregion_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the subregion's name"

            timestamps()
        end

        create table(:cuisine_region_country_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the country's name"

            timestamps()
        end

        create table(:cuisine_region_province_translations, primary_key: false) do
            translation()

            add :term, :string,
                null: false#,
                # comment: "The localised term for the province's name"

            timestamps()
        end

        create table(:cuisine_regions) do
            add :ref, :string,
                null: false

            add :ref_id, :uuid,
                null: false

            translate :continent, null: false

            translate :subregion, null: true

            translate :country, null: true

            translate :province, null: true

            timestamps()
        end

        create index(:cuisine_regions, [:ref], unique: true)
        create index(:cuisine_regions, [:ref_id], unique: true)
        execute("CREATE UNIQUE INDEX cuisine_regions_region_index ON cuisine_regions(continent, COALESCE(subregion, 0), COALESCE(country, 0), COALESCE(province, 0))")
    end
end
