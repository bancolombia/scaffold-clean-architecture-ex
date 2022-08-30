defmodule Ca.New.DaTest do
  use ExUnit.Case
  
  import Mock
  
  alias Mix.Tasks.Ca.New.Da

  test "should shows helper information" do
    assert :ok === Da.run([])
  end

  test "should returns the version" do
    Da.run(["-v"])
    assert_received {:mix_shell, :info, ["Scaffold version v" <> _]}
  end
  
end
