defmodule DataTypeUtilsTest do
  use ExUnit.Case
  alias ElixirStructureManager.Core.DataTypeUtils

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

end
