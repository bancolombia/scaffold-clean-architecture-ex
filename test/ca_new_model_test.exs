defmodule Ca.New.ModelTest do
  use ExUnit.Case
  import Mock
  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.New.Model, as: Task

  test "should shows helper information" do
    assert :ok === Task.run([])
  end

  test "should returns the version" do
    Task.run(["-v"])
    assert_received {:mix_shell, :info, ["Scaffold version v" <> _]}
  end

  test "should shows helper information when parameters are invalid" do
    assert :ok === Task.run(["-b"])
  end

  test "should create a model" do
    with_mocks([{ApplyTemplate, [], [apply: fn _type, _name -> :ok end]}]) do
      Task.run(["model_name"])
      assert called(ApplyTemplate.apply(:model, "model_name"))
    end
  end

  test "should create a model and behaviour without name" do
    with_mocks([{ApplyTemplate, [], [apply: fn _type, _name -> :ok end]}]) do
      Task.run(["model_name", "-b"])
      assert called(ApplyTemplate.apply(:model, "model_name"))
      assert called(ApplyTemplate.apply(:behaviour, "model_name_behaviour"))
    end
  end

  test "should create a model and behaviour with name" do
    with_mocks([{ApplyTemplate, [], [apply: fn _type, _name -> :ok end]}]) do
      Task.run(["model_name", "-n", "behaviour_name"])
      assert called(ApplyTemplate.apply(:model, "model_name"))
      assert called(ApplyTemplate.apply(:behaviour, "behaviour_name"))
    end
  end
end
