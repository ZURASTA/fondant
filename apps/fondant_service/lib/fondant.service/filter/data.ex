defmodule Fondant.Service.Filter.Data do
    @moduledoc """
      Migrate the dataset used for filters.
    """

    require Logger
    import Ecto.Query

    alias Fondant.Service.Filter

    @doc """
      Clean the database.

      Removes all filters and history of the dataset.
    """
    @spec clean() :: :ok
    def clean() do
        Ecto.Multi.new
        |> Ecto.Multi.delete_all(:delete_allergens, Filter.Type.Allergen.Model)
        |> Ecto.Multi.delete_all(:delete_allergen_names, Filter.Type.Allergen.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_cuisines, Filter.Type.Cuisine.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_names, Filter.Type.Cuisine.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_regions, Filter.Type.Cuisine.Region.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_continents, Filter.Type.Cuisine.Region.Translation.Continent.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_subregions, Filter.Type.Cuisine.Region.Translation.Subregion.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_countrys, Filter.Type.Cuisine.Region.Translation.Country.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_provinces, Filter.Type.Cuisine.Region.Translation.Province.Model)
        |> Ecto.Multi.delete_all(:delete_diets, Filter.Type.Diet.Model)
        |> Ecto.Multi.delete_all(:delete_diet_names, Filter.Type.Diet.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_ingredients, Filter.Type.Ingredient.Model)
        |> Ecto.Multi.delete_all(:delete_ingredient_names, Filter.Type.Ingredient.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_ingredient_types, Filter.Type.Ingredient.Translation.Type.Model)
        |> Ecto.Multi.delete_all(:delete_data, Filter.Data.Model)
        |> Fondant.Service.Repo.transaction
        |> case do
            { :ok, _ } -> :ok
            { :error, changeset } ->
                Logger.debug("change: #{inspect(changeset.errors)}")
                { :error, "Failed clean the database" }
        end
    end
end
