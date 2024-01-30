defmodule ApplyTemplatesTest do
  use ExUnit.Case
  alias ElixirStructureManager.Core.ApplyTemplate
  alias ElixirStructureManager.Utils.FileGenerator

  import Mock

  test "should resolve and apply templates" do
    with_mock FileGenerator, execute_actions: fn _actions, _tokens -> :ok end do
      Enum.each(
        [
          :model,
          :behaviour,
          :usecase,
          :secretsmanager,
          :asynceventbus,
          :generic,
          :redis,
          :repository,
          :restconsumer,
          :asynceventhandler,
          :cognitotokenprovider,
          :dynamo,
          :metrics,
          :distillery,
          :sonar
        ],
        fn template ->
          res = ApplyTemplate.apply(template, "sample_name")
          assert :ok == res
        end
      )
    end
  end

  test "should handle error when no template" do
    assert_raise Mix.Error, fn ->
      ApplyTemplate.apply(:non_existing_template, "sample_model")
    end
  end
end
