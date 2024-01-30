defmodule Ca.Apply.ConfigTest do
  use ExUnit.Case
  import Mock
  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.Apply.Config, as: Task

  test "should shows helper information when invalid args" do
    assert :ok === Task.run(["invalid", "args"])
  end

  test "should create a config" do
    with_mocks([{ApplyTemplate, [], [apply: fn _type, _name -> :ok end]}]) do
      Task.run(["--type", "distillery"])
      assert called(ApplyTemplate.apply(:distillery, "non_required"))
    end
  end
end
