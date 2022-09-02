defmodule Ca.New.UsecaseTest do
  use ExUnit.Case
  
  alias Mix.Tasks.Ca.New.Usecase

  test "should shows helper information" do
    assert :ok === Usecase.run([])
  end

  test "should returns the version" do
    Usecase.run(["-v"])
    assert_received {:mix_shell, :info, ["Scaffold version v" <> _]}
  end
  
end
