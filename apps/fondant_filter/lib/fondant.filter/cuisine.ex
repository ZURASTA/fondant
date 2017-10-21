defmodule Fondant.Filter.Cuisine do
    @moduledoc """
      A struct representing an cuisine filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is an `integer`.

      ###:name
      Is the localised name of the cuisine. Is a `string`.

      ###:region
      Is the cuisine region. Is a `Fondant.Filter.Cuisine.Region`.
    """

    defstruct [
        :id,
        :name,
        :region
    ]

    @type t :: %Fondant.Filter.Cuisine{
        id: integer,
        name: String.t,
        region: Fondant.Filter.Cuisine.Region.t
    }
end
