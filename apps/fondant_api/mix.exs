defmodule Fondant.API.Mixfile do
    use Mix.Project

    def project do
        [
            app: :fondant_api,
            version: "0.1.0",
            build_path: "../../_build",
            config_path: "../../config/config.exs",
            deps_path: "../../deps",
            lockfile: "../../mix.lock",
            elixir: "~> 1.5",
            elixirc_paths: elixirc_paths(Mix.env),
            build_embedded: Mix.env == :prod,
            start_permanent: Mix.env == :prod,
            deps: deps()
        ]
    end

    # Configuration for the OTP application
    #
    # Type "mix help compile.app" for more information
    def application do
        [extra_applications: [:logger]]
    end

    # Specifies which paths to compile per environment.
    defp elixirc_paths(:test), do: ["lib", "test/support", "../fondant_service/test/support"]
    defp elixirc_paths(_),     do: ["lib"]

    # Dependencies can be Hex packages:
    #
    #   {:my_dep, "~> 0.3.0"}
    #
    # Or git/path repositories:
    #
    #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    #
    # To depend on another app inside the umbrella:
    #
    #   {:my_app, in_umbrella: true}
    #
    # Type "mix help deps" for more examples and options
    defp deps() do
        [
            { :fondant_filter, in_umbrella: true },
            { :fondant_service, in_umbrella: true, only: :test }
        ]
    end
end
