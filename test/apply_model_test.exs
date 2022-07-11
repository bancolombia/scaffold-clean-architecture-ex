defmodule ApplyModelTest do
  use ExUnit.Case
  alias ElixirStructureManager.Core.ApplyModelTemplate

  import Mock
  import ExUnit.Assertions

  test "should create a model" do
    
    with_mocks([

      {Application, [], [app_dir: fn(:elixir_structure_manager) -> "user/path/scaffold_project/" end]},
        {File, [], [write!: fn(_path, _content) -> :ok end]},
      {File, [], [read: fn (_path) -> { :ok, "{application_name}-{model_name}" } end]}
    ]) do

      res = ApplyModelTemplate.create_model("test_project", "test_model")
      assert :ok == res
    end
     
  end

  test "should fail when model name is invalid name" do
    assert_raise Mix.Error, ~r"Invalid name indicated: ", fn -> 
      ApplyModelTemplate.create_model("test_project", "invalidmodelname")
    end
  end

  test "should fail when file does not exist" do
    
    with_mock File, [read: fn(_path) -> {:error, :enoent} end] do

      res = ApplyModelTemplate.create_model("test_project", "test_model")

     assert {:error, :enoent} == res 
    end
    
  end
end
