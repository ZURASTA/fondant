defmodule Fondant.Service.Repo.Migrations.Data do
    use Ecto.Migration

    def change do
        create table(:data) do
            add :timestamp, :string,
                null: false

            timestamps()
        end
    end
end
