defmodule Ca.UpdateTest do
  use ExUnit.Case

  import Mock
  alias ElixirStructureManager.Utils.Hex.Packages
  alias Mix.Tasks.Ca.Update, as: Task

  test "should shows helper information" do
    assert :ok === Task.run(["-h"])
  end

  test "should execute actions on project" do
    mix_content = """
    defp deps do
      [
        {:dep_a, "~> 0.19.0"},
        {:dep_b, "~> 0.10.0"},
        {:dep_c, "~> 0.10.0", only: [:test]},
        {:dep_d, path: "some", only: [:test]}
      ]
    end
    """

    config = %{
      deps: [
        {:dep_a, "~> 0.19.0"},
        {:dep_b, "~> 0.10.0"},
        {:dep_c, "~> 0.10.0", only: [:test]},
        {:dep_d, path: "some", only: [:test]}
      ]
    }

    mix_expected =
      """
      defp deps do
        [
          {:dep_a, "~> 1.0.0"},
          {:dep_b, "~> 1.0.0"},
          {:dep_c, "~> 1.0.0", [only: [:test]]},
          {:dep_d, [path: "some", only: [:test]]}
        ]
      end
      """
      |> Code.format_string!()

    with_mocks([
      {Packages, [], [get_stable_version: fn _package -> {:ok, {"1.0.0", %{}}} end]},
      {Mix.Project, [], [project_file: fn -> "" end, config: fn -> config end]},
      {File, [],
       [
         read!: fn _file -> mix_content end,
         write!: fn _file, _content -> :ok end
       ]}
    ]) do
      Task.execute({[], []})
      assert called(File.write!(:_, mix_expected))
    end
  end
end
