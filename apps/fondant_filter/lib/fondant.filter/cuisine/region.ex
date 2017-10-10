defmodule Fondant.Filter.Cuisine.Region do
    @moduledoc """
      A struct representing an cuisine region filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is an `integer`.

      ###:continent
      Is the localised continent of the cuisin region. Is a `string`.

      ###:subregion
      Is the localised subregion of the cuisin region. Is a `string`.

      ###:country
      Is the localised country of the cuisin region. Is a `string`.

      ###:province
      Is the localised province of the cuisin region. Is a `string`.
    """

    defstruct [
        :id,
        :continent,
        :subregion,
        :country,
        :province
    ]

    @type t :: %Fondant.Filter.Cuisine.Region{
        id: integer,
        continent: String.t,
        subregion: String.t,
        country: String.t,
        province: String.t
    }
end
