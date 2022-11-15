# Elixir Structure Manager

Elixir plugin to create an elixir application based on Clean Architecture following our best practices.

## Install

[HexDocs](https://hex.pm/packages/elixir_structure_manager)

```bash
mix archive.install hex elixir_structure_manager <version>
```

## Tasks

```shell
mix help | grep "mix ca."
```

| Task                     | Description                                      |
| ------------------------ | -------------------------------------------------|
| mix ca.new.structure     | Creates a new clean architecture application.    |
| mix ca.new.model         | Creates a new model with empty properties        |
| mix ca.new.usecase       | Creates a new usecase                            |
| mix ca.new.da            | Creates a new driven adapter                     |
| mix ca.new.ep            | Creates a new entry point                        |
| mix ca.config.distillery | Creates distillery configuration                 |
| mix ca.config.metrics    | Adds telemetry configuration                     |


#### Task detail

```bash
mix <task> -h
```

Example

```bash
mix ca.new.structure -h
```

```
Creates a new Clean architecture scaffold

    $ mix ca.new.structure [application_name]
    $ mix ca.new.structure [application_name] --metrics --distillery
    $ mix ca.new.structure [application_name] -m -d
```

### Generate Project

The `ca.new.structure` task will generate a clean architecture structure in your project.

```bash
mix ca.new.structure <project-name>

mix ca.new.structure <project-name> --metrics --distillery

mix ca.new.structure <project-name> -m -d
```

**_The structure will look like this_**

```
app
├── config
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   └── test.exs
├── lib
│   ├── application.ex
│   ├── config
│   │   ├── app_config.ex
│   │   └── config_holder.ex
│   ├── domain
│   │   ├── behaviours
│   │   ├── model
│   │   └── use_cases
│   ├── infrastructure
│   │   ├── driven_adapters
│   │   └── entry_points
│   │       ├── api_rest.ex
│   │       └── health_check.ex
│   └── utils
│       ├── certificates_admin.ex
│       ├── custom_telemetry.ex
│       └── data_type_utils.ex
├── mix.exs
├── mix.lock
└── rel
    ├── config.exs
    ├── plugins
    └── vm.args
```

### Generate Model

Creates a new model for the clean architecture project

```bash
mix ca.new.model <model_name>
mix ca.new.model <model_name> --behaviour
mix ca.new.model <model_name> -b

mix ca.new.model <model_name> --behaviour-name <behaviour_name>
mix ca.new.model <model name> -n <behaviour_name>
```

**_This task will generate something like that:_**

```
domain
├── behaviours
│   └── model_behaviour.ex
└── model
    └── model.ex
```

### Generate Use Case

Creates a new usecase for the clean architecture project

```bash
mix ca.new.usecase <name_usecase>
```

**_This task will generate something like that:_**

```
domain
└── use_cases
    └── use_case.ex
```

### Generate Driven Adapter

Creates a new driven adapter for the clean architecture project.

```bash
mix ca.new.da --type <driven_adapter_name>
```

Type param options:

- generic
- redis
- asynceventbus
- secrestsmanager
- repository
- restconsumer


```bash
mix ca.new.da --type <driven_adapter_name> --name <my_adapter>

mix ca.new.da -t driven_adapter_name -n <my_adapter>
```

**_This task will generate something like that:_**

```
infrastructure
└── driven_adapters
  └── rest_consumer
      └── <name>
          ├── data
          │ ├── <name>_request.ex
          │ └── <name>_response.ex
          └── <name>_adapter.ex
```

### Generate Entry Point

Creates a new driven adapter for the clean architecture project 

```bash
mix ca.new.ep --type <entry_point_name>
```

Type param options:

- asynceventhandler

```bash
mix ca.new.ep --type <entry_point_name> --name <my_entry_point>

mix ca.new.ep -t entry_point_name -n <my_entry_point>
```

**_This task will generate something like that:_**

```
infrastructure
└── entry_points
    └── async_messages
        └── async_message_handlers.ex
```

### Generate Metrics

Creates distillery configuration for the clean architecture project

```bash
 mix ca.config.metrics
```

### Distillery

Creates distillery configuration for the clean architecture project

```bash
mix ca.config.distillery
```

---

## Uninstall

Get version

```shell
mix archive
```

```shell
mix archive.uninstall elixir_structure_manager-<version>
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/elixir_structure_manager](https://hexdocs.pm/elixir_structure_manager).

