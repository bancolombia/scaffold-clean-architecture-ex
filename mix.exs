defmodule ElixirStructureManager.MixProject do
  use Mix.Project

  @version "0.1.8"

  def project do
    [
      app: :elixir_structure_manager,
      version: @version,
      elixir: "~> 1.12",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.xml": :test
      ],
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  defp description() do
    """
    Plugin to generate a clean architecture scaffold.
    """
  end

  defp package() do
    [
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Juan Esteban", "Santiago Calle", "Juan Carlos Galvis"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/bancolombia/scaffold-clean-architecture-ex"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 5.0"},
      {:mock, "~> 0.3.7", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:git_hooks, "~> 0.7", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
    ]
  end
end
