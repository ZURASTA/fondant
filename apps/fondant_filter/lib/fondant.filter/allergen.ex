defmodule Fondant.Filter.Allergen do
    @moduledoc """
      A struct representing an allergen filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is a `Fondant.Filter.id`.

      ###:name
      Is the localised name of the allergen. Is a `string`.
    """

    defstruct [
        :id,
        :name
    ]

    @type t :: %Fondant.Filter.Allergen{
        id: Fondant.Filter.id,
        name: String.t
    }
end
