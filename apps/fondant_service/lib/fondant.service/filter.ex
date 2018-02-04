defmodule Fondant.Service.Filter do
    use GenServer

    alias Fondant.Service.Filter
    require Logger
    import Ecto.Query

    def child_spec(_args) do
        %{
            id: __MODULE__,
            start: { __MODULE__, :start_link, [] },
            type: :worker
        }
    end

    def start_link() do
        GenServer.start_link(__MODULE__, [], name: __MODULE__)
    end

    def handle_call({ :get, { type, id, locale } }, from, state) do
        Task.start(fn -> GenServer.reply(from, Filter.Type.get(type, id, locale)) end)
        { :noreply, state }
    end
    def handle_call({ :find, { type, query } }, from, state) do
        Task.start(fn -> GenServer.reply(from, Filter.Type.find(type, query)) end)
        { :noreply, state }
    end
    def handle_call({ :find, { type, query, options } }, from, state) do
        Task.start(fn -> GenServer.reply(from, Filter.Type.find(type, query, options)) end)
        { :noreply, state }
    end
    def handle_call({ :queryables, { type } }, from, state) do
        Task.start(fn -> GenServer.reply(from, Filter.Type.queryables(type)) end)
        { :noreply, state }
    end
    def handle_call({ :db, :clean }, _from, state), do: { :reply, Filter.Data.clean(), state }
    def handle_call({ :db, :migrate }, _from, state), do: { :reply, Filter.Data.migrate(), state }
end
