defmodule Fondant.Service.Filter.Type.Allergen do
    @moduledoc """
      Support allergen filters.
    """

    @behaviour Fondant.Service.Filter.Type

    alias Fondant.Service.Filter
    alias Fondant.Service.Filter.Type.Allergen
    require Logger
    use Translecto.Query

    @impl Filter.Type
    def get(id, locale) do
        query = from allergen in Allergen.Model,
            where: allergen.id == ^id,
            locales: ^Fondant.Service.Locale.to_locale_id_list!(locale),
            translate: name in allergen.name,
            select: %{
                id: allergen.id,
                name: name.term
            }

        case Fondant.Service.Repo.one(query) do
            nil -> { :error, "Allergen does not exist" }
            result -> { :ok, Map.merge(%Fondant.Filter.Allergen{}, result) }
        end
    end
end
