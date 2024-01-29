defmodule Config.Distillery do
  @moduledoc false

  def actions do
    provider = """
      set config_providers: [{Distillery.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}] # Use config file at runtime
    """

    %{
      transformations: [
        {:inject_dependency, ~s|{:distillery, "~> 2.1"}|},
        {:run_task, :install_deps},
        {:run_task, :distillery_init},
        {:insert_after, "rel/config.exs", provider, regex: ~r|"rel\/vm\.args"(\r?)\n|}
      ]
    }
  end

  def tokens(_opts) do
    []
  end
end
