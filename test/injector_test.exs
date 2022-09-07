defmodule InjectorTest do
  use ExUnit.Case
  alias ElixirStructureManager.Utils.Injector
  import ExUnit.Assertions

  defp file_content() do
    """
    defmodule HelloWorld.MixProject do
      defp deps do
        [
          {:plug_cowboy, "~> 2.2"},
          {:poison, "~> 4.0"},
          {:cors_plug, "~> 2.0"}
        ]
      end
    end
    """
  end

  defp file_content_injected() do
    """
    defmodule HelloWorld.MixProject do
      defp deps do
        [
          {:some_dependency, "~> 1.0"},
          {:plug_cowboy, "~> 2.2"},
          {:poison, "~> 4.0"},
          {:cors_plug, "~> 2.0"}
        ]
      end
    end
    """
  end

  defp file_corrupt_content() do
    """
    defmodule HelloWorld.MixProject do
    defp notfound do
      [
        {:plug_cowboy, "~> 2.2"},
        {:poison, "~> 4.0"},
        {:cors_plug, "~> 2.0"}
      ]
      end
    end
    """
  end

  test "should inject dependency in file mix.exs when file content is given" do
    content = file_content()
    expected = file_content_injected()

    {:ok, res} = Injector.inject_dependency(content, ~s|{:some_dependency, "~> 1.0"}|, nil)

    assert expected === res
  end

  test "should return already_injected atom when dependency to inject already exists" do
    content = file_content_injected()

    {:ok, res} = Injector.inject_dependency(content, ~s|{:poison, "~> 4.0"}|, nil)

    assert content === res
  end

  test "should return unable_to_inject atom when mix.exs file is corrupt" do
    corrupt_content = file_corrupt_content()

    {:error, {reason, _, _}} =
      Injector.inject_dependency(corrupt_content, ~s|{:some_dependency, "~> 1.0"}|, nil)

    assert :no_match === reason
  end

  test "should inject before" do
    content = "start-.end"
    expected = "start-here.end"

    {:ok, res} = Injector.insert_before(content, "here", regex: ~r|\.|)

    assert expected === res
  end

  test "should append end" do
    content = "start"
    expected = "start-end"

    {:ok, res} = Injector.append_end(content, "-end", nil)

    assert expected === res
  end
end
