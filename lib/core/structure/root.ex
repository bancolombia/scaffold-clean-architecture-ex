defmodule Structure.Root do
  @moduledoc false
  @base "/priv/templates/structure/"

  def actions do
    %{
      create: %{
        "{app_snake}/mix.exs" => @base <> "mix.exs",
        "{app_snake}/config/config.exs" => @base <> "config.exs",
        "{app_snake}/config/dev.exs" => @base <> "dev.exs",
        "{app_snake}/config/test.exs" => @base <> "test.exs",
        "{app_snake}/config/prod.exs" => @base <> "prod.exs",
        "{app_snake}/lib/infrastructure/entry_points/api_rest.ex" => @base <> "api_rest.ex",
        "{app_snake}/lib/infrastructure/entry_points/health_check.ex" =>
          @base <> "health_check.ex",
        "{app_snake}/lib/config/config_holder.ex" => @base <> "config_holder.ex",
        "{app_snake}/lib/config/app_config.ex" => @base <> "app_config.ex",
        "{app_snake}/lib/utils/certificates_admin.ex" => @base <> "certificates_admin.ex",
        "{app_snake}/lib/utils/data_type_utils.ex" => @base <> "data_type_utils.ex",
        "{app_snake}/lib/application.ex" => @base <> "application.ex",
        "{app_snake}/.gitignore" => @base <> "gitignore.txt",
        "{app_snake}/.formatter.exs" => @base <> "formatter.exs",
        "{app_snake}/.dockerignore" => @base <> "dockerignore.txt",
        "{app_snake}/resources/docker/Dockerfile" => @base <> "dockerfile.txt",
        "{app_snake}/test/infrastructure/entry_points/api_rest_test.exs" =>
          @base <> "api_rest_test.exs",
        "{app_snake}/test/{app_snake}_application_test.exs" => @base <> "test_application.exs",
        "{app_snake}/test/test_helper.exs" => @base <> "test_helper.exs",
        "{app_snake}/coveralls.json" => @base <> "coveralls.json"
      },
      folders: [
        "{app_snake}/lib/infrastructure/driven_adapters/",
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
