defmodule Fondant.Service.Filter.Type.Cuisine.Model do
    use Ecto.Schema
    use Translecto.Schema.Translatable
    import Ecto.Changeset
    @moduledoc """
      A model representing the different cuisines.

      ##Fields

      ###:id
      Is the unique reference to the cuisine entry. Is an `integer`.

      ###:name
      Is the name of the cuisine. Is a `translatable`.

      ###:region_id
      Is the reference to the region the cuisine belongs to. Is an
      `integer` to `Fondant.Service.Filter.Type.Cuisine.Region.Model`.
    """

    schema "cuisines" do
        translatable :name, Fondant.Service.Filter.Type.Cuisine.Translation.Name.Model
        belongs_to :region, Fondant.Service.Filter.Type.Cuisine.Region.Model
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * `name` field is translatable
      * `name` field is required
      * `region_id` field is required
      * `region_id` field is associated with an entry in `Fondant.Service.Filter.Type.Cuisine.Region.Model`
      * `name` field is unique
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> translatable_changeset(params, [:name])
        |> cast(params, [:region_id])
        |> validate_required([:name, :region_id])
        |> assoc_constraint(:region)
        |> unique_constraint(:name)
    end
end
