defmodule Ca.New.ModelTest do
  use ExUnit.Case
  
  import Mock
  
  alias Mix.Tasks.Ca.New.Model
  alias ElixirStructureManager.Utils.DataTypeUtils
  alias ElixirStructureManager.Core.ApplyModelTemplate

  test "should shows helper information" do
    assert :ok === Model.run([])
  end

  test "should returns the version" do
    Mix.Tasks.Ca.New.Model.run(["-v"])
    assert_received {:mix_shell, :info, ["Scaffold version v" <> _]}
  end
  
  test "should shows helper information when parameters are invalid" do
    assert :ok === Model.run(["--bh"])
  end
  
  test "should return error when an elixir project is invalid" do
    with_mock(Keyword, [fetch: fn(_app_name, :app) -> :error end]) do
      Model.run(["model_name"])
      assert_received {:mix_shell, :error, ["It is not an elixir project"]}
    end
  end

  test "should create a model" do
    with_mocks([
      {Keyword, [], [fetch: fn(_app_name, :app) -> {:ok, :hello_world} end]},
      {ApplyModelTemplate, [], [create_model: fn ("hello_world", "model_name") -> :ok end]}
    ]) do
      Model.run(["model_name"])
      assert_received {:mix_shell, :info, ["* Creating model " <> _]}
      assert_received {:mix_shell, :info, ["* Model" <> _]}
    end
  end
  
  test "should create a model and behaviour without name" do
    with_mocks([
      {Keyword, [], [fetch: fn(_app_name, :app) -> {:ok, :hello_world} end]},
      {DataTypeUtils, [], [parse_opts: fn (_args, _switches) -> {[bh: true], ["model_name"]} end]},
      {ApplyModelTemplate, [], [create_model: fn ("hello_world", "model_name") -> :ok end]},
      {ApplyModelTemplate, [], [create_behaviour: fn ("hello_world", "model_name_behaviour") -> :ok end]}
    ]) do
      Model.run(["model_name", "--bh"])
      assert_received {:mix_shell, :info, ["* Creating model " <> _]}
      assert_received {:mix_shell, :info, ["* Model" <> _]}

      assert_received {:mix_shell, :info, ["* Creating behaviour " <> _]}
      assert_received {:mix_shell, :info, ["* Behaviour " <> _]}
    end
  end

  test "should create a model and behaviour with name" do
    with_mocks([
      {Keyword, [], [fetch: fn(_app_name, :app) -> {:ok, :hello_world} end]},
      {DataTypeUtils, [], [parse_opts: fn (_args, _switches) -> {[bh: true, bh_name: "bh-name"], ["model_name"]} end]},
      {ApplyModelTemplate, [], [create_model: fn ("hello_world", "model_name") -> :ok end]},
      {ApplyModelTemplate, [], [create_behaviour: fn ("hello_world", "bh-name") -> :ok end]}
    ]) do
      Model.run(["model_name", "--bh"])
      assert_received {:mix_shell, :info, ["* Creating model " <> _]}
      assert_received {:mix_shell, :info, ["* Model" <> _]}

      assert_received {:mix_shell, :info, ["* Creating behaviour " <> _]}
      assert_received {:mix_shell, :info, ["* Behaviour " <> _]}
    end
  end
end
