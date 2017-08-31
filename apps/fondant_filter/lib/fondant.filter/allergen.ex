defmodule Fondant.Filter.Allergen do
    @moduledoc """
      A struct representing an allergen filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is an `integer`.

      ###:name
      Is the localised name of the allergen. Is a `string`.
    """

    defstruct [
        :id,
        :name
    ]
end
