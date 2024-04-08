defmodule Ca.TestTest do
  use ExUnit.Case

  import Mock
  alias Mix.Tasks.Ca.Test, as: Task
  alias ElixirStructureManager.Utils.FileGenerator

  test "should shows helper information" do
    assert :ok === Task.run(["-h"])
  end

  test "should execute actions on project" do
    with_mocks([{FileGenerator, [], [execute_actions: fn _actions, _tokens -> :ok end]}]) do
      Task.execute({nil, []})
      assert called(FileGenerator.execute_actions(:_, :_))
    end
  end
end
