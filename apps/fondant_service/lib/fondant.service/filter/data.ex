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

    @spec ref_id(integer, integer) :: Fondant.Filter.id
    defp ref_id(timestamp, index) when timestamp <= 4611686018427387903 and index <= 281474976710655, do: UUID.binary_to_string!(<<index :: 48, 4 :: 4, 0 :: 12, 2 :: 2, timestamp :: 62>>)

    @spec get_migration(String.t, String.t, integer) :: Yum.Migration.t
    defp get_migration(path, type, timestamp \\ -1) do
        Yum.Data.reduce_migrations(%Yum.Migration{}, type, fn
            migration = %{ "add" => add, "timestamp" => timestamp }, acc ->
                timestamp = String.to_integer(timestamp)

                add = Stream.iterate(0, &(&1 + 1))
                |> Stream.map(&ref_id(timestamp, &1))
                |> Enum.zip(add)

                Yum.Migration.merge(Yum.Migration.new(%{ migration | "add" => add }), acc)
            migration, acc -> Yum.Migration.merge(Yum.Migration.new(migration), acc)
        end, timestamp, path)
    end

    @spec find_ref(String.t, Ecto.Queryable.t) :: Ecto.Queryable.t
    defp find_ref(ref, model) do
        query = from item in model,
            where: item.ref == ^ref
    end

    @spec run(Yum.Migration.t, module) :: :ok | { :error, String.t }
    defp run(migration, type) do
        model = Module.safe_concat(type, Model)

        Yum.Migration.transactions(migration)
        |> Enum.reduce(Ecto.Multi.new(), fn
            { :move, { old_ref, new_ref } }, transaction -> Ecto.Multi.update_all(transaction, { :move_ref, { old_ref, new_ref } }, find_ref(old_ref, model), [set: [ref: new_ref]])
            { :delete, ref }, transaction ->
                Enum.reduce(model.translations(), transaction, fn { field, translation_model }, transaction ->
                    query = from translation in translation_model,
                        join: item in ^model, on: item.ref == ^ref,
                        where: field(item, ^field) == translation.translate_id

                    Ecto.Multi.delete_all(transaction, { :delete_translation, { ref, translation_model } }, query)
                end)
                |> Ecto.Multi.delete_all({ :delete_ref, ref }, find_ref(ref, model))
        end)
        |> Fondant.Service.Repo.transaction
        |> case do
            { :ok, _ } -> :ok
            { :error, operation, value, _ } ->
                Logger.debug("change #{inspect(operation)} (#{migration.timestamp}): #{inspect(value)}")
                { :error, "Failed to run migration (#{migration.timestamp})" }
            _ -> { :error, "Failed to run migration (#{migration.timestamp})"}
        end
    end
end
