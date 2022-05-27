# ElixirStructureManager

**Elixir plugin to create an elixir application based on Clean Architecture following our best practices!

## Installation

To verify what dependencies do you have, please run
```
$ mix archive
```

First you need to install the dependency locally

```bash
$ mix archive.install hex elixir_structure_manager-0.1.0
```

To verify that the dependency was installed successfully, run

```bash
$ mix help
```

And you must see a task:
```
mix create_structure
```

if you have an old version, please uninstall it with
```
$ mix archive.uninstall
```

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `elixir_structure_manager` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:elixir_structure_manager, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixir_structure_manager](https://hexdocs.pm/elixir_structure_manager).

