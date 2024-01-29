defmodule Ca.New.EpTest do
  use ExUnit.Case
  import Mock
  alias ElixirStructureManager.Core.ApplyTemplate
  alias Mix.Tasks.Ca.New.Ep, as: Task

  test "should shows helper information when invalid args" do
    assert :ok === Task.run(["invalid", "args"])
  end

  test "should create an ep" do
    with_mocks([{ApplyTemplate, [], [apply: fn _type, _name -> :ok end]}]) do
      Task.run(["--type", "asynceventbus"])
      assert called(ApplyTemplate.apply(:asynceventbus, "valid_name"))
    end
  end
end
