defmodule ElixirStructureManager.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_structure_manager,
      version: "0.1.0",
      elixir: "~> 1.12",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
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
      maintainers: ["Juan Esteban"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/juanes1a/elixir_structure_manager"}
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
      {:poison, "~> 4.0"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mock, "~> 0.3.7", only: :test}
    ]
  end
end
