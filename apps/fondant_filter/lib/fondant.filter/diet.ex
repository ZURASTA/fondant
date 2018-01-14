defmodule Fondant.Filter.Diet do
    @moduledoc """
      A struct representing an diet filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is a `Fondant.Filter.id`.

      ###:name
      Is the localised name of the diet. Is a `string`.
    """

    defstruct [
        :id,
        :name
    ]

    @type t :: %Fondant.Filter.Diet{
        id: Fondant.Filter.id,
        name: String.t
    }
end
