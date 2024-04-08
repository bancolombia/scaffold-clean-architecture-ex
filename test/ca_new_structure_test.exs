defmodule Ca.New.StructureTest do
  use ExUnit.Case

  alias Mix.Tasks.Ca.New.Structure, as: Task

  test "should shows helper information" do
    assert :ok === Task.run([])
  end

  test "should returns the version" do
    Task.run(["-v"])
    assert_received {:mix_shell, :info, ["Scaffold version v" <> _]}
  end

  test "should generate project" do
    project_name = "generated"
    Task.run([project_name])
    assert_received {:mix_shell, :info, ["iex -S mix"]}
    File.rm_rf(project_name)
  end

  test "should generate project with metris and sonar" do
    project_name = "generated2"
    Task.run([project_name, "-m", "-s"])
    assert_received {:mix_shell, :info, ["iex -S mix"]}
    assert File.exists?("generated2/lib/utils/custom_telemetry.ex")
    File.rm_rf(project_name)
  end
end
