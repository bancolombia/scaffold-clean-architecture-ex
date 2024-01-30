defmodule Config.Aws do
  @moduledoc false
  @base "/priv/templates/config/aws/"

  def actions do
    %{
      transformations: [
        {:inject_dependency, ~s|{:ex_aws_sts, "~> 2.0"}|},
        {:inject_dependency, ~s|{:hackney, "~> 1.0"}|},
        {:inject_dependency, ~s|{:sweet_xml, "~> 0.7"}|},
        {:inject_dependency, ~s|{:jason, "~> 1.4"}|},
        {:inject_dependency, ~s|{:configparser_ex, "~> 4.0"}|},
        {:append_end, "config/dev.exs", @base <> "aws_base.ex"},
        {:append_end, "config/test.exs", @base <> "aws_base.ex"},
        {:append_end, "config/prod.exs", @base <> "aws_base_prod.ex"}
      ]
    }
  end
end
