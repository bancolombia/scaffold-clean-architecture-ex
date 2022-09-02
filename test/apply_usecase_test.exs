defmodule ApplyUsecaseTest do
  use ExUnit.Case
  alias ElixirStructureManager.Core.ApplyUseCaseTemplate

  import Mock
  import ExUnit.Assertions

  test "should create a usecase" do
    
    with_mocks([

      {Application, [], [app_dir: fn(:elixir_structure_manager) -> "user/path/scaffold_project/" end]},
        {File, [], [write!: fn(_path, _content) -> :ok end]},
      {File, [], [read: fn (_path) -> { :ok, "{application_name}-{usecase_name}" } end]}
    ]) do

      res = ApplyUseCaseTemplate.create_usecase("test_project", "test_usecase")
      assert :ok == res
    end
     
  end

  test "should fail when usecase name is invalid name" do
    assert_raise Mix.Error, ~r"Invalid name indicated: ", fn -> 
      ApplyUseCaseTemplate.create_usecase("test_project", "invalidmodelname")
    end
  end

  
end
