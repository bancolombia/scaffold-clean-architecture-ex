defmodule Ca.New.StructureTest do
  use ExUnit.Case

  alias Mix.Tasks.Ca.New.Structure

  test "should shows helper information" do
    assert :ok === Structure.run([])
  end

  test "should returns the version" do
    Structure.run(["-v"])
    assert_received {:mix_shell, :info, ["Scaffold version v" <> _]}
  end

  test "should generate project" do
    project_name = "generated"
    Structure.run([project_name])
    assert_received {:mix_shell, :info, ["iex -S mix"]}
    File.rm_rf(project_name)
  end

  test "should generate project with metris and distillery" do
    project_name = "generated2"
    Structure.run([project_name, "-m", "-d"])
    assert_received {:mix_shell, :info, ["iex -S mix"]}
    assert File.exists?("generated2/lib/utils/custom_telemetry.ex")
    File.rm_rf(project_name)
  end
end
