defmodule Ca.New.StructureTest do
  use ExUnit.Case
  
  import Mock
  
  alias Mix.Tasks.Ca.New.Structure

  test "should shows helper information" do
    assert :ok === Structure.run([])
  end

  test "should returns the version" do
    Structure.run(["-v"])
    assert_received {:mix_shell, :info, ["Scaffold version v" <> _]}
  end
  
end
