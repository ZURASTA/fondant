defmodule Fondant.Filter.Ingredient do
    @moduledoc """
      A struct representing an ingredient filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is a `Fondant.Filter.id`.

      ###:name
      Is the localised name of the ingredient. Is a `string`.

      ###:type
      Is the localised category type of the ingredient. Is a `string`.
    """

    defstruct [
        :id,
        :name,
        :type
    ]

    @type t :: %Fondant.Filter.Ingredient{
        id: Fondant.Filter.id,
        name: String.t,
        type: String.t | nil
    }
end
