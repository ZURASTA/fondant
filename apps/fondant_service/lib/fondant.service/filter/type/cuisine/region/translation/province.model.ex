defmodule Fondant.Service.Filter.Type.Cuisine.Region.Translation.Province.Model do
    use Ecto.Schema
    use Translecto.Schema.Translation
    import Ecto.Changeset
    import Protecto
    @moduledoc """
      A model representing the different province names for the different
      translations.

      ##Fields

      ###:translate_id
      Is the reference to the associated group of region province entries.
      Is an `integer`.

      ###:locale_id
      Is the reference to the specific translations for a given localisation.
      Is an `integer`.

      ###:term
      Is the region province. Is a `string`.
    """

    schema "cuisine_region_province_translations" do
        translation()
        field :term, :string
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * it's a translation
      * `term` field is required
      * formats the `term` field as lowercase
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> translation_changeset(params)
        |> cast(params, [:term])
        |> validate_required([:term])
        |> format_lowercase(:term)
    end
end
