defmodule DA.CognitoTokenProvider.Test do
  use ExUnit.Case

  import Mock
  alias Mix.Tasks.Ca.New.Da, as: Task
  alias ElixirStructureManager.Core.ApplyTemplate

  test "should shows helper information when invalid args" do
    assert :ok === Task.run(["invalid", "args"])
  end

  test "should create an driven adapter" do
    with_mocks([{ApplyTemplate, [], [apply: fn _type, _name -> :ok end]}]) do
      Task.run(["--type", "cognitotokenprovider"])
      assert called(ApplyTemplate.apply(:cognitotokenprovider, "valid_name"))
    end
  end
end
