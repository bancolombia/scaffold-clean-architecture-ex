defmodule ApplyTemplatesTest do
  use ExUnit.Case
  alias ElixirStructureManager.Core.ApplyTemplates

  import Mock

  test "should get variable list" do
    project_name = "test_project"
    res = ApplyTemplates.manage_application_name(project_name)
    assert {:ok, _project_name, "TestProject"} = res
  end

  test "should get invalid appliation name" do
    res = ApplyTemplates.manage_application_name("invalidname")
    assert {:error, :invalid_application_name} = res
  end

  test "should get variables list" do
    res = ApplyTemplates.create_variables_list(:test, "test")
    assert {:ok, [
      %{name: "{application_name_atom}", value: :test},
      %{name: "{module_name}", value: "test"}
    ]} = res
  end

  test "should load template file" do
      res = ApplyTemplates.load_template_file("test/assets/create_structure.exs")
      assert %{name: "test", template_path: "templates/mix.txt"} = res
  end

  test "should create directories and files" do
    with_mock File, [mkdir_p: fn(_path) -> :ok end] do
      res = ApplyTemplates.create_content("/path")
      assert :ok == res
    end
  end

  test "should create files" do
    template = [
      %{
        folder: "config",
        path: "./data/config",
        files: [
          %{
            name: "config.exs",
            template_path: "./lib/create_structure/templates/config.txt"
          },
          %{
            name: "dev.exs",
            template_path: "./lib/create_structure/templates/dev.txt"
          }
        ]
      },
      %{
        folder: "driven_adapters",
        path: "./data/lib/driven_adapters/",
        files: []
      },
      %{
        folder: "entry_points",
        path: "./data/lib/entry_points",
        files: [
          %{
            name: "api_rest.ex",
            template_path: "./lib/create_structure/templates/api_rest.txt"
          }
        ]
      }
    ]

    variable_list = [
      %{name: "{application_name_atom}", value: ":test_project"},
      %{name: "{module_name}", value: "TestProject"}
    ]

    with_mocks([
      {File, [], [mkdir_p: fn(_path) -> :ok end]},
      {File, [], [read: fn(_path) -> {:ok, "{module_name} - :{application_name_atom}"} end]},
      {File, [], [write: fn(_path, _content) -> :ok end]}
    ]) do

      res = ApplyTemplates.create_folder(template, "test_folder", variable_list)
      assert :ok == res

    end
  end

end
