defmodule Fondant.Service.Filter.Type.Allergen.Model do
    use Ecto.Schema
    use Translecto.Schema.Translatable
    import Ecto.Changeset
    @moduledoc """
      A model representing the different food allergens.

      ##Fields

      ###:id
      Is the unique reference to the allergen entry. Is an `integer`.

      ###:ref
      Is the name of the resource. Is a `string`.

      ###:ref_id
      Is the unique ID to externally reference the diet. Is an `uuid`.

      ###:name
      Is the name of the allergen. Is a `translatable`.
    """

    schema "allergens" do
        field :ref, :string
        field :ref_id, Ecto.UUID
        translatable :name, Fondant.Service.Filter.Type.Allergen.Translation.Name.Model
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * `name` field is translatable
      * `ref` field is required
      * `ref_id` field is required
      * `name` field is required
      * `ref` field is unique
      * `ref_id` field is unique
      * `name` field is unique
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> translatable_changeset(params, [:name])
        |> cast(params, [:ref, :ref_id])
        |> validate_required([:ref, :ref_id, :name])
        |> unique_constraint(:ref)
        |> unique_constraint(:ref_id)
        |> unique_constraint(:name)
    end
end
