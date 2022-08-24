defmodule DataTypeUtilsTest do
  use ExUnit.Case
  alias ElixirStructureManager.Utils.DataTypeUtils

  defstruct [
    name: "",
    last_name: "",
    company: ""
  ]

  def new(name, last_name, company) do
    %__MODULE__{
      name: name,
      last_name: last_name,
      company: company
    }
  end

  test "should normalize a objects" do
    json = """
    {"name": "name test", "last_name": "last name test", "company": "Bancolombia"}
    """

    json_map = %{name: "name test", last_name: "last name test", company: "Bancolombia"}
    list_test = [1, "string test", :an_atom]

    model = new("santi", "calle", "bancolombia")

    {:ok, decoded} = Poison.decode(json)
    res = DataTypeUtils.normalize(decoded)
    assert json_map == res

    res_list = DataTypeUtils.normalize(list_test)
    assert list_test == res_list

    res_structure = DataTypeUtils.normalize(model)
    assert model == res_structure
  end

  test "should return arguments values" do

    switches = [type: :string, name: :string]

    values = DataTypeUtils.parse_opts(
      ["--type", "secrets", "--name", "test"], switches)  
    assert values == {[type: "secrets", name: "test"], []}
    
    values_without_flag = DataTypeUtils.parse_opts(
      ["username", "--name", "test"], switches)
    
    assert values_without_flag == {[name: "test"], ["username"]}
  end
  
  test "should raise a message when args are invalid" do

    switches = [type: :string, name: :string]

    assert_raise Mix.Error, ~r/Invalid option:\s+/,
      fn -> DataTypeUtils.parse_opts(["--types", "secrets"], switches) 
      end

    # assert values == {[type: "secrets", name: "test"], []}
    
    #values_without_flag = DataTypeUtils.parse_opts(
    #  ["username", "--names", "test"], switches)
    
    # assert values_without_flag == {[name: "test"], ["username"]}
  end
end
