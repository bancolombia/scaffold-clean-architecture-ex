defmodule FileGeneratorTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias ElixirStructureManager.Utils.FileGenerator
  alias ElixirStructureManager.Utils.Injector

  import Mock
  import ExUnit.Assertions
  import ExUnit.CaptureLog

  defp deps_content do
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

  defp deps_content_injected do
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

  test "should return error when create file" do
    with_mocks([
      {File, [],
       [
         mkdir_p!: fn _path -> :error end,
         read: fn _path -> :not_found end
       ]}
    ]) do
      actions = %{
        create: %{"{placeholder}/sample.ex" => "content {placeholder}"},
        transformations: []
      }

      tokens = [{"{placeholder}", "replaced"}]
      execute = fn -> FileGenerator.execute_actions(actions, tokens) end

      assert :ok == execute.()
      assert called(File.mkdir_p!("replaced"))
      assert capture_log(execute) =~ "Error creating file \"{placeholder}/sample.ex\" :error"
    end
  end

  test "should raise an error when update files" do
    with_mocks([
      {File, [],
       [
         read: fn _path -> {:ok, ~s|{:some_dependency, "~> 1.0"}|} end,
         read!: fn _path -> deps_content() end
       ]},
      {Injector, [], [inject_dependency: fn _content, _dependency, _opts -> :other end]}
    ]) do
      actions = %{
        create: %{},
        transformations: [{:inject_dependency, ~s|{:some_dependency, "~> 1.0"}|}]
      }

      assert_raise RuntimeError, ~r/Error processing file/, fn ->
        FileGenerator.execute_actions(actions, [])
      end
    end
  end
end
