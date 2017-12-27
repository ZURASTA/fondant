defmodule Fondant.Service.Data.Model do
    use Ecto.Schema
    import Ecto
    import Ecto.Changeset
    import Protecto
    @moduledoc """
      A model representing the metadata around datasets.

      ##Fields

      ###:id
      Is the unique reference to the entry. Is an `integer`.

      ###:timestamp
      The last timestamp the dataset was migrated to. Is a `string`.
    """

    schema "data" do
        field :timestamp, :string
        timestamps()
    end

    @doc """
      Builds a changeset based on the `struct` and `params`.

      Enforces:
      * `timestamp` field is supplied
      * `timestamp` field contains only digits
    """
    def changeset(struct, params \\ %{}) do
        struct
        |> cast(params, [:timestamp])
        |> validate_required(:timestamp)
        |> validate_format(:timestamp, ~r/^\d+$/, message: "must contain only digits")
    end
end
