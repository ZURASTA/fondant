# Fondant (Translatable Food Filters)

[![Stories in Ready](https://badge.waffle.io/ZURASTA/fondant.png?label=ready&title=Ready)](https://waffle.io/ZURASTA/fondant?utm_source=badge)

Exposes searchable filters for normalising food related tags. The filters are created from the [Food-Data](https://github.com/ZURASTA/Food-Data) dataset. These filters can be searched using localisable terms, and are exposed using unique IDs that can be used to reference them elsewhere.


### Usage

The service component (`Fondant.Service`) is an OTP application that should be started prior to making any requests to the service. This component should only be interacted with to configure/control the service explicitly.

An API (`Fondant.API`) is provided to allow for convenient interaction with the service from external applications.


Filters
-------

A filter is a tag to refer to a specific data reference from the [Food-Data](https://github.com/ZURASTA/Food-Data) dataset. These filters can be referenced using their unique ID or discovered using their localised terms.

Support for credentials can be added by implementing the behaviours in `Fondant.Service.Filter.Type`.

### Allergen

Support for allergen filter types is provided by the `Fondant.Service.Filter.Type.Allergen` implementation. This corresponds to allergen items in the [allergen directory](https://github.com/ZURASTA/Food-Data/tree/master/allergens) of the dataset.

### Diet

Support for diet filter types is provided by the `Fondant.Service.Filter.Type.Diet` implementation. This corresponds to diet items in the [diet directory](https://github.com/ZURASTA/Food-Data/tree/master/diets) of the dataset.

### Ingredient

Support for ingredient filter types is provided by the `Fondant.Service.Filter.Type.Ingredient` implementation. This corresponds to ingredient items in the [ingredient directory](https://github.com/ZURASTA/Food-Data/tree/master/ingredients) of the dataset.

### Cuisine Region

Support for cuisine region filter types is provided by the `Fondant.Service.Filter.Type.Cuisine.Region` implementation. This corresponds to cuisine region items in the [cuisine directory](https://github.com/ZURASTA/Food-Data/tree/master/cuisines) of the dataset whose type is set to a regional variant.

### Cuisine

Support for cuisine dish filter types is provided by the `Fondant.Service.Filter.Type.Cuisine` implementation. This corresponds to cuisine dish items in the [cuisine directory](https://github.com/ZURASTA/Food-Data/tree/master/cuisines) of the dataset whose type is set to a dish variant.


Dataset
-------

The dataset can be managed using functions presented in the `Fondant.Service.Filter.Data` or `Fondant.API.Filter` modules. For handling cleaning the dataset, migrating the dataset, rolling back the dataset, and retrieving the history of migrations.


Configuration
-------------

The service may be configured with the following options:

### Server

The service can be made available through various methods customisable using the `:server` key in the service and API configs. The `:server:` key expects the value to be a function that accepts a module and returns a value acceptable by the `server` argument of GenServer requests, or name field of GenServer registration. Some examples of this can be:

#### Local Named Server

```elixir
config :fondant_service,
    server: &(&1)

config :fondant_api,
    server: &(&1)
```

#### Distributed Named Server

```elixir
config :fondant_service,
    server: &(&1)

config :fondant_api,
    server: &({ &1, :"foo@127.0.0.1" })
```

#### Swarm Registered Server

```elixir
config :fondant_service,
    server: &({ :via, :swarm, &1 })

config :fondant_api,
    server: &({ :via, :swarm, &1 })
```

### Setup Mode

The service has two setup modes: `:auto` and `:manual`. When the service is started in `:auto`, it will automatically handle creating and migrating the database. When the service is started in `:manual`, the state of the database is left up to the user to manually setup.

By default the service runs in `:auto` mode. To change this behaviour, pass in the `{ :setup_mode, mode }` when starting the application.

### Database

__Warning:__ This service will soon be shifting away from Postgres to managing the constant data store itself.

The database options can be configured by providing the config for the key `Fondant.Service.Repo`.

For details on how to configure an [Ecto repo](https://hexdocs.pm/ecto/Ecto.Repo.html).

__Note:__ Relies on PostgreSQL for auto-generating UUIDs (uuid-ossp extension).
