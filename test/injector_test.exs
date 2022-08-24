defmodule InjecterTest do
  use ExUnit.Case
  alias ElixirStructureManager.Utils.Injector

  import Mock
  import ExUnit.Assertions
  
  def file_content() do
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
  
  test "should inject dependecy in file mix.exs when file content is given" do

    with_mocks([
      {File, [], [write!: fn(_path, _content) -> :ok end]}
    ]) do
    
      assert :ok === Injector.inject_dependency(file_content(), "lib/mock.exs", ~s|{:some_dependency, "~> 1.0"}|)
    end

  end
  
  test "should inject dependecy in file mix.exs when file path is given" do

    with_mocks([
      {File, [], [read!: fn(_path_file) -> file_content() end]},
      {File, [], [write!: fn(_path, _content) -> :ok end]}
    ]) do
    
      assert :ok === Injector.inject_dependency("mix.exs", ~s|{:some_dependency, "~> 1.0"}|)
    end

  end

  test "should return already_injected atom when dependency to inject already exists" do

    with_mocks([
      {File, [], [read!: fn(_path_file) -> file_content() end]}
    ]) do
    
      assert :already_injected === Injector.inject_dependency("mix.exs", ~s|{:poison, "~> 4.0"}|)
    end

    assert :already_injected === Injector.inject_dependency(file_content(), "lib/mock.exs", ~s|{:poison, "~> 4.0"}|)
  end
  
  test "should return unable_to_inject atom when mix.exs file is corrupt" do
    
    corrupt_content = """
    defmodule HelloWorld.MixProject do
    defp notfound do
      [
        {:plug_cowboy, "~> 2.2"},
        {:poison, "~> 4.0"},
        {:cors_plug, "~> 2.0"}
      ]
      end
    end
    """

    with_mocks([
      {File, [], [read!: fn(_path_file) -> corrupt_content end]}
    ]) do
    
      assert {:error, :unable_to_inject} === Injector.inject_dependency("mix.exs", ~s|{:some_dependency, "~> 1.0"}|)
    end

    assert {:error, :unable_to_inject} === Injector.inject_dependency(corrupt_content, "lib/mock.exs", ~s|{:some_dependency, "~> 1.0"}|)
  end
end
