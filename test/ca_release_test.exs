defmodule Ca.ReleaseTest do
  use ExUnit.Case

  import Mock
  alias ElixirStructureManager.Utils.FileGenerator
  alias Mix.Tasks.Ca.Release, as: Task

  test "should shows helper information" do
    assert :ok === Task.run(["-h"])
  end

  test "should execute actions on project" do
    with_mocks([{FileGenerator, [], [execute_actions: fn _actions, _tokens -> :ok end]}]) do
      Task.execute({["skip-test": false, "skip-release": false], []})
      assert called(FileGenerator.execute_actions(:_, :_))
    end
  end

  test "should execute actions inside container project" do
    with_mocks([{FileGenerator, [], [execute_actions: fn _actions, _tokens -> :ok end]}]) do
      Task.execute({[container: true], []})
      assert called(FileGenerator.execute_actions(:_, :_))
    end
  end
end
