defmodule Fondant.Filter.Cuisine.Region do
    @moduledoc """
      A struct representing an cuisine region filter.

      ##Fields

      ###:id
      Is the unique id to reference this filter. Is a `string`.

      ###:continent
      Is the localised continent of the cuisine region. Is a `string`.

      ###:subregion
      Is the localised subregion of the cuisine region. Is a `string`.

      ###:country
      Is the localised country of the cuisine region. Is a `string`.

      ###:province
      Is the localised province of the cuisine region. Is a `string`.
    """

    defstruct [
        :id,
        :continent,
        :subregion,
        :country,
        :province
    ]

    @type t :: %Fondant.Filter.Cuisine.Region{
        id: String.t,
        continent: String.t,
        subregion: String.t | nil,
        country: String.t | nil,
        province: String.t | nil
    }
end
