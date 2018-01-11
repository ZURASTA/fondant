defmodule Fondant.Service.Filter.Type.Cuisine.Region.Model do
    use Ecto.Schema
    use Translecto.Schema.Translatable
    import Ecto.Changeset
    @moduledoc """
      A model representing the different cuisine regions.

      ##Fields

      ###:id
      Is the unique reference to the region entry. Is an `integer`.

      ###:ref
      Is the name of the resource. Is a `string`.

      ###:ref_id
      Is the unique ID to externally reference the ingredient. Is an `uuid`.

      ###:continent
      Is the continent of the region. Is a `translatable`.

      ###:subregion
      Is the subregion of the region. Is a `translatable`.

      ###:country
      Is the country of the region. Is a `translatable`.

      ###:province
      Is the province of the region. Is a `translatable`.
    """

    schema "cuisine_regions" do
        field :ref, :string
        field :ref_id, Ecto.UUID
        translatable :continent, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Continent.Model
        translatable :subregion, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Subregion.Model
        translatable :country, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Country.Model
        translatable :province, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Province.Model
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * `continent` field is translatable
      * `subregion` field is translatable
      * `country` field is translatable
      * `province` field is translatable
      * `ref` field is required
      * `ref_id` field is required
      * `continent` field is required
      * `ref` field is unique
      * `ref_id` field is unique
      * checks uniqueness of the given region fields
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> translatable_changeset(params, [:continent, :subregion, :country, :province])
        |> cast(params, [:ref, :ref_id])
        |> validate_required([:ref, :ref_id, :continent])
        |> unique_constraint(:ref)
        |> unique_constraint(:ref_id)
        |> unique_constraint(:region)
    end
end
