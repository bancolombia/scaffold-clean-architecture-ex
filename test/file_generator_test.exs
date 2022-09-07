defmodule FileGeneratorTest do
  use ExUnit.Case
  alias ElixirStructureManager.Utils.FileGenerator

  import Mock
  import ExUnit.Assertions

  defp deps_content() do
    """
    defmodule HelloWorld.MixProject do
      defp deps do
        [
          {:plug_cowboy, "~> 2.2"},
          {:poison, "~> 4.0"},
          {:cors_plug, "~> 2.0"}
        ]
      end
    end
    """
  end

  defp deps_content_injected() do
    """
    defmodule HelloWorld.MixProject do
      defp deps do
        [
          {:some_dependency, "~> 1.0"},
          {:plug_cowboy, "~> 2.2"},
          {:poison, "~> 4.0"},
          {:cors_plug, "~> 2.0"}
        ]
      end
    end
    """
  end

  test "should create dirs" do
    with_mocks([{File, [], [mkdir_p!: fn _path -> :ok end, read: fn _path -> :not_found end]}]) do
      actions = %{folders: ["{app}/sample"], create: %{}, transformations: []}
      tokens = [{"{app}", "replaced"}]
      res = FileGenerator.execute_actions(actions, tokens)

      assert :ok == res
      assert called(File.mkdir_p!("replaced/sample"))
    end
  end

  test "should create file" do
    with_mocks([
      {File, [],
       [
         mkdir_p!: fn _path -> :ok end,
         write!: fn _path, _content -> :ok end,
         read: fn _path -> :not_found end
       ]}
    ]) do
      actions = %{
        create: %{"{placeholder}/sample.ex" => "content {placeholder}"},
        transformations: []
      }

      tokens = [{"{placeholder}", "replaced"}]
      res = FileGenerator.execute_actions(actions, tokens)

      assert :ok == res
      assert called(File.mkdir_p!("replaced"))
      assert called(File.write!("replaced/sample.ex", "content replaced"))
    end
  end

  test "should update files" do
    with_mocks([
      {File, [],
       [
         mkdir_p!: fn _path -> :ok end,
         write!: fn _path, _content -> :ok end,
         read: fn _path -> {:ok, ~s|{:some_dependency, "~> 1.0"}|} end,
         read!: fn _path -> deps_content() end
       ]}
    ]) do
      actions = %{
        create: %{},
        transformations: [{:inject_dependency, ~s|{:some_dependency, "~> 1.0"}|}]
      }

      tokens = []
      res = FileGenerator.execute_actions(actions, tokens)

      assert :ok == res
      assert called(File.read!("mix.exs"))
      assert called(File.write!("mix.exs", deps_content_injected()))
    end
  end
end
