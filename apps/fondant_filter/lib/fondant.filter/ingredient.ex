defmodule Fondant.Filter.Ingredient do
    @moduledoc """
      A struct representing an ingredient filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is an `integer`.

      ###:name
      Is the localised name of the ingredient. Is a `string`.

      ###:name
      Is the localised category type of the ingredient. Is a `string`.
    """

    defstruct [
        :id,
        :name,
        :type
    ]
end
