defmodule Structure.Root do
  @moduledoc false
  @base "/priv/templates/structure/"

  def actions() do
    %{
      create: %{
        "{app_snake}/mix.exs" => @base <> "mix.exs",
        "{app_snake}/config/config.exs" => @base <> "config.exs",
        "{app_snake}/config/dev.exs" => @base <> "dev.exs",
        "{app_snake}/config/test.exs" => @base <> "test.exs",
        "{app_snake}/config/prod.exs" => @base <> "prod.exs",
        "{app_snake}/lib/entry_points/api_rest.ex" => @base <> "api_rest.ex",
        "{app_snake}/lib/config/config_holder.ex" => @base <> "config_holder.ex",
        "{app_snake}/lib/config/app_config.ex" => @base <> "app_config.ex",
        "{app_snake}/lib/utils/certificates_admin.ex" => @base <> "certificates_admin.ex",
        "{app_snake}/lib/utils/data_type_utils.ex" => @base <> "data_type_utils.ex",
        "{app_snake}/lib/application.ex" => @base <> "application.ex",
        "{app_snake}/.gitignore" => @base <> "gitignore.txt",
        "{app_snake}/.formatter.exs" => @base <> "formatter.exs"
      },
      folders: [
        "{app_snake}/lib/driven_adapters/",
        "{app_snake}/lib/domain/model/",
        "{app_snake}/lib/domain/use_cases/",
        "{app_snake}/lib/domain/behaviours/"
      ],
      transformations: []
    }
  end

  def tokens(_opts) do
    []
  end
end
