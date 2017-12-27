defmodule Fondant.Service.Data do
    @moduledoc """
      Migrate the dataset used for filters.
    """

    require Logger
    import Ecto.Query

    @doc """
      Clean the database.

      Removes all filters and history of the dataset.
    """
    @spec clean() :: :ok
    def clean() do
        Ecto.Multi.new
        |> Ecto.Multi.delete_all(:delete_allergens, Fondant.Service.Filter.Type.Allergen.Model)
        |> Ecto.Multi.delete_all(:delete_allergen_names, Fondant.Service.Filter.Type.Allergen.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_cuisines, Fondant.Service.Filter.Type.Cuisine.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_names, Fondant.Service.Filter.Type.Cuisine.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_regions, Fondant.Service.Filter.Type.Cuisine.Region.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_continents, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Continent.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_subregions, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Subregion.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_countrys, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Country.Model)
        |> Ecto.Multi.delete_all(:delete_cuisine_region_provinces, Fondant.Service.Filter.Type.Cuisine.Region.Translation.Province.Model)
        |> Ecto.Multi.delete_all(:delete_diets, Fondant.Service.Filter.Type.Diet.Model)
        |> Ecto.Multi.delete_all(:delete_diet_names, Fondant.Service.Filter.Type.Diet.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_ingredients, Fondant.Service.Filter.Type.Ingredient.Model)
        |> Ecto.Multi.delete_all(:delete_ingredient_names, Fondant.Service.Filter.Type.Ingredient.Translation.Name.Model)
        |> Ecto.Multi.delete_all(:delete_ingredient_types, Fondant.Service.Filter.Type.Ingredient.Translation.Type.Model)
        |> Ecto.Multi.delete_all(:delete_data, Fondant.Service.Data.Model)
        |> Fondant.Service.Repo.transaction
        |> case do
            { :ok, _ } -> :ok
            { :error, changeset } ->
                Logger.debug("change: #{inspect(changeset.errors)}")
                { :error, "Failed clean the database" }
        end
    end
end
