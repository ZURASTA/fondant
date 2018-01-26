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
    def get_migration(path, type, timestamp \\ -1) do
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

    @spec migrate(String.t) :: :ok | { :error, String.t }
    def migrate(path \\ "apps/fondant_service/priv/data") do
        Ecto.Multi.new()
        |> Ecto.Multi.run(:last_migration, fn _ ->
            timestamp = case Fondant.Service.Repo.one(last(Filter.Data.Model)) do
                nil -> -1
                migration -> String.to_integer(migration.timestamp)
            end

            { :ok, timestamp }
        end)
        |> Ecto.Multi.merge(fn changes ->
            timestamp = changes[:last_migration]

            Ecto.Multi.new()
            |> migrate_allergens(timestamp, path)
            |> migrate_diets(timestamp, path)
            |> migrate_ingredients(timestamp, path)
        end)
        |> Ecto.Multi.merge(fn changes ->
            timestamp = Enum.reduce(changes, -1, fn
                { { :new_timestamp, _ }, new_timestamp }, timestamp when new_timestamp > timestamp -> new_timestamp
                _, timestamp -> timestamp
            end)

            if timestamp == -1 do
                Ecto.Multi.error(Ecto.Multi.new(), :error_current, "Nothing to migrate")
            else
                Ecto.Multi.insert(Ecto.Multi.new(), :mark_migration, Filter.Data.Model.changeset(%Filter.Data.Model{}, %{ timestamp: to_string(timestamp) }))
            end
        end)
        |> Fondant.Service.Repo.transaction
        |> case do
            { :ok, changes } ->
                Logger.info("Migrated from (#{changes[:last_migration]}) to (#{changes[:mark_migration].timestamp})")
                :ok
            { :error, :error_current, value, _ } ->
                Logger.debug("change #{:error_current}: #{inspect(value)}")
                { :error, value }
            { :error, operation, value, _ } ->
                Logger.debug("change #{inspect(operation)}: #{inspect(value)}")
                { :error, "Failed to run migration" }
            _ -> { :error, "Failed to run migration" }
        end
    end

    @spec migrate_allergens(Ecto.Multi.t, integer, String.t) :: Ecto.Multi.t
    defp migrate_allergens(transaction, timestamp, data) do
        get_migration(data, "allergens", timestamp)
        |> run(transaction, data, Filter.Type.Allergen, fn path, file ->
            Yum.Data.reduce_allergens(%{}, fn
                { _, %{ "translation" => translations } }, _ -> %{ name: translations }
                _, acc -> acc
            end, path, &(&1 == file))
        end)
    end

    @spec migrate_diets(Ecto.Multi.t, integer, String.t) :: Ecto.Multi.t
    defp migrate_diets(transaction, timestamp, data) do
        get_migration(data, "diets", timestamp)
        |> run(transaction, data, Filter.Type.Diet, fn path, file ->
            Yum.Data.reduce_diets(%{}, fn
                { _, %{ "translation" => translations } }, _ -> %{ name: translations }
                _, acc -> acc
            end, path, &(&1 == file))
        end)
    end

    @spec migrate_ingredients(Ecto.Multi.t, integer, String.t) :: Ecto.Multi.t
    defp migrate_ingredients(transaction, timestamp, data) do
        get_migration(data, "ingredients", timestamp)
        |> run(transaction, data, Filter.Type.Cuisine, fn path, file ->
            Yum.Data.reduce_ingredients(%{}, fn
                { _, %{ "translation" => translations } }, _, _ -> %{ name: translations }
                _, _, acc -> acc
            end, "", path, &(&1 == file))
        end)
    end

    @spec find_ref(String.t, Ecto.Queryable.t) :: Ecto.Queryable.t
    defp find_ref(ref, model) do
        from item in model,
            where: item.ref == ^ref
    end

    @spec prepare_translation(Yum.Data.translation_tree | String.t, String.t, [String.t], [[term: String.t, locale_id: integer, inserted_at: DateTime.t, updated_at: DateTime.t]]) :: [[term: String.t, locale_id: integer, inserted_at: DateTime.t, updated_at: DateTime.t]]
    defp prepare_translation(translation, field \\ "term", language \\ [], inserts \\ [])
    defp prepare_translation(string, field, [field|language], inserts) when is_binary(string) do
        case Fondant.Service.Locale.to_locale_id(Enum.reverse(language) |> Enum.join("_")) do
            nil -> inserts
            locale -> [[term: string, locale_id: locale, inserted_at: DateTime.utc_now, updated_at: DateTime.utc_now]|inserts]
        end
    end
    defp prepare_translation(string, _, _, inserts) when is_binary(string), do: inserts
    defp prepare_translation(data, field, language, inserts) do
        Enum.reduce(data, inserts, fn { locale, translation }, inserts ->
            prepare_translation(translation, field, [to_string(locale)|language], inserts)
        end)
    end

    @spec translate_ids(map(), String.t) :: keyword(integer)
    defp translate_ids(changes, ref) do
        Enum.reduce(changes, [], fn
            { { :add_translation_head, { ^ref, _, translation_field } }, %{ translate_id: translate_id } }, acc -> [{ translation_field, translate_id }|acc]
            _, acc -> acc
        end)
    end

    @spec insert_translations(Ecto.Multi.t, String.t, module, %{ optional(atom) => Yum.Data.translation_tree }) :: Ecto.Multi.t
    defp insert_translations(transaction, ref, type, translation_fields) do
        Enum.reduce(translation_fields, transaction, fn { translation_field, translations }, transaction ->
            translation_model = Module.safe_concat([type, Translation, atom_to_module(translation_field), Model])
            translation_head = { :add_translation_head, { ref, translation_model, translation_field } }

            case prepare_translation(translations) do
                [] -> transaction
                [translation] -> Ecto.Multi.insert(transaction, translation_head, translation_model.changeset(struct(translation_model), Map.new(translation)))
                [translation|translations] ->
                    Ecto.Multi.insert(transaction, translation_head, translation_model.changeset(struct(translation_model), Map.new(translation)))
                    |> Ecto.Multi.merge(fn changes ->
                        Ecto.Multi.insert_all(Ecto.Multi.new(), { :add_translation, { ref, translation_model } }, translation_model, Enum.map(translations, &([{ :translate_id, changes[translation_head].translate_id }|&1])))
                    end)
            end
        end)
    end

    @spec delete_translations(Ecto.Multi.t, String.t, module) :: Ecto.Multi.t
    defp delete_translations(transaction, ref, model) do
        Enum.reduce(model.translations(), transaction, fn { field, translation_model }, transaction ->
            query = from translation in translation_model,
                join: item in ^model, on: item.ref == ^ref,
                where: field(item, ^field) == translation.translate_id

            Ecto.Multi.delete_all(transaction, { :delete_translation, { ref, translation_model } }, query)
        end)
    end

    @spec run(Yum.Migration.t, Ecto.Multi.t, String.t, module, ((String.t, String.t) -> %{ optional(atom) => Yum.Data.translation_tree })) :: :ok | { :error, String.t }
    defp run(migration, transaction, path, type, get_translations) do
        model = Module.safe_concat(type, Model)

        Yum.Migration.transactions(migration)
        |> Enum.reduce(transaction, fn
            { :update, ref }, transaction ->
                file = Enum.join([""|String.split(ref, "/", trim: true)], "/")
                translation_fields = get_translations.(path, file)

                delete_translations(transaction, ref, model)
                |> insert_translations(ref, type, translation_fields)
                |> Ecto.Multi.merge(&Ecto.Multi.update_all(Ecto.Multi.new(), { :update_ref, { ref, model } }, find_ref(ref, model), [set: [{ :updated_at, DateTime.utc_now }|translate_ids(&1, ref)]]))
            { :add, { id, ref } }, transaction ->
                file = Enum.join([""|String.split(ref, "/", trim: true)], "/")
                translation_fields = get_translations.(path, file)

                insert_translations(transaction, ref, type, translation_fields)
                |> Ecto.Multi.merge(&Ecto.Multi.insert(Ecto.Multi.new(), { :add_ref, { ref, model } }, model.changeset(struct(model), Map.merge(%{ ref: ref, ref_id: id }, Map.new(translate_ids(&1, ref))))))
            { :move, { old_ref, new_ref } }, transaction -> Ecto.Multi.update_all(transaction, { :move_ref, { { old_ref, new_ref }, model } }, find_ref(old_ref, model), [set: [ref: new_ref]])
            { :delete, ref }, transaction ->
                delete_translations(transaction, ref, model)
                |> Ecto.Multi.delete_all({ :delete_ref, { ref, model } }, find_ref(ref, model))
        end)
        |> Ecto.Multi.run({ :new_timestamp, type }, fn _ -> { :ok, migration.timestamp } end)
    end

    @spec atom_to_module(atom) :: atom
    defp atom_to_module(name) do
        String.to_atom(format_as_module(to_string(name)))
    end

    @spec format_as_module(String.t) :: String.t
    defp format_as_module(name) do
        name
        |> String.split(".")
        |> Enum.map(fn module ->
            String.split(module, "_") |> Enum.map(&String.capitalize(&1)) |> Enum.join
        end)
        |> Enum.join(".")
    end
end
