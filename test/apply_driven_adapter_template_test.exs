defmodule ApplyDrivenAdapterTemplateTest do
  use ExUnit.Case
  alias ElixirStructureManager.Core.ApplyDrivenAdapterTemplate
  alias ElixirStructureManager.Utils.FileGenerator
  alias ElixirStructureManager.Utils.Injector

  import Mock
  import ExUnit.Assertions

  test "should create a driven adapter" do
    
    with_mocks([

      {FileGenerator, [], [create_file: fn(_project_da_path, _template_path ,_token_list) -> :ok end]},
      {File, [], [exists?: fn (_path) -> true end]},
      {Injector, [], [inject_dependency: fn (_path, _dependency) -> :ok end]}
    ]) do

      res = ApplyDrivenAdapterTemplate.create_driven_adapter("test_project", "secret_name", :secretsmanager)
      assert :ok == res
    end
     
  end

  test "should create a driven adapter when directories doesn't exists" do
    
    with_mocks([

      {FileGenerator, [], [create_file: fn(_project_da_path, _template_path ,_token_list) -> :ok end]},
      {File, [], [exists?: fn (_path) -> false end]},
      {File, [], [mkdir!: fn (_path) -> true end]},
      {Injector, [], [inject_dependency: fn (_path, _dependency) -> :ok end]}
    ]) do

      res = ApplyDrivenAdapterTemplate.create_driven_adapter("test_project", "secret_name", :secretsmanager)
      assert :ok == res
    end
     
  end

  test "should fail when driven adapter name is invalid name" do
   assert_raise Mix.Error, ~r"Invalid name indicated: ", fn -> 
     ApplyDrivenAdapterTemplate.create_driven_adapter("test_project", "invalidname", :secretsmanager)
   end
 end

  test "should fail when driven adapter type is invalid" do
   assert_raise Mix.Error, ~r"Invalid driven adapter parameter. Please verify de documentation to see the diferent driven adapters types", fn -> 
     ApplyDrivenAdapterTemplate.create_driven_adapter("test_project", "valid_name", :invalid)
   end
 end
end
