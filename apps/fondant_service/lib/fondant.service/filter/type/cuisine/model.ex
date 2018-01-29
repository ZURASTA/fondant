defmodule Fondant.Service.Filter.Type.Cuisine.Model do
    use Ecto.Schema
    use Translecto.Schema.Translatable
    import Ecto.Changeset
    @moduledoc """
      A model representing the different cuisines.

      ##Fields

      ###:id
      Is the unique reference to the cuisine entry. Is an `integer`.

      ###:ref
      Is the name of the resource. Is a `string`.

      ###:ref_id
      Is the unique ID to externally reference the cuisine region. Is an `uuid`.

      ###:name
      Is the name of the cuisine. Is a `translatable`.

      ###:region_id
      Is the reference to the region the cuisine belongs to. Is an
      `integer` to `Fondant.Service.Filter.Type.Cuisine.Region.Model`.
    """

    schema "cuisines" do
        field :ref, :string
        field :ref_id, Ecto.UUID
        translatable :name, Fondant.Service.Filter.Type.Cuisine.Translation.Name.Model
        belongs_to :region, Fondant.Service.Filter.Type.Cuisine.Region.Model
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * `name` field is translatable
      * `ref` field is required
      * `ref_id` field is required
      * `name` field is required
      * `region_id` field is required
      * `region_id` field is associated with an entry in `Fondant.Service.Filter.Type.Cuisine.Region.Model`
      * `ref` field is unique
      * `ref_id` field is unique
      * `name` field is unique
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> translatable_changeset(params, [:name])
        |> cast(params, [:ref, :ref_id, :region_id])
        |> validate_required([:ref, :ref_id, :name, :region_id])
        |> assoc_constraint(:region)
        |> unique_constraint(:ref)
        |> unique_constraint(:ref_id)
        |> unique_constraint(:name)
    end
end
