[![Build Status](https://github.com/bancolombia/scaffold-clean-architecture-ex/actions/workflows/main.yml/badge.svg)](https://github.com/bancolombia/scaffold-clean-architecture-ex/actions/workflows/main.yml) [![Hex.pm](https://img.shields.io/hexpm/v/elixir_structure_manager.svg)](https://hex.pm/packages/elixir_structure_manager) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/elixir_structure_manager/)
[![Coverage Status](https://coveralls.io/repos/github/bancolombia/scaffold-clean-architecture-ex/badge.svg?branch=main)](https://coveralls.io/bancolombia/scaffold-clean-architecture-ex?branch=main)

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

| Task                  | Description                                   |
|-----------------------|-----------------------------------------------|
| mix ca.new.structure  | Creates a new clean architecture application. |
| mix ca.new.model      | Creates a new model with empty properties     |
| mix ca.new.usecase    | Creates a new usecase                         |
| mix ca.new.da         | Creates a new driven adapter                  |
| mix ca.new.ep         | Creates a new entry point                     |
| mix ca.apply.config   | Applies some project configuration            |


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

| Name            | Description                    |
|-----------------|--------------------------------|
| asynceventbus   | RabbitMQ message sender        |
| dynamo          | AWS Dynamo DB client           |
| generic         | Empty structure for an adapter |
| redis           | Redis client                   |
| repository      | Ecto repository setup          |
| restconsumer    | HTTP(S) Client                 |
| secrestsmanager | AWS Secrets Manager client     |


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

| Name              | Description               |
|-------------------|---------------------------|
| asynceventhandler | RabbitMQ message listener |

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

### Apply a Project Configuration

Applies a configuration for the clean architecture project

```bash
 mix ca.apply.config -t <config_type>
```

Type param options:

| Name       | Description                                                 |
|------------|-------------------------------------------------------------|
| metrics    | Add metrics setup for adapters and exporter                 |
| distillery | Configures releases with distillery (will be deprecated)    |
| sonar      | Configures some snoar dependencies for analysis and reports |

#### Metrics

This configuration type will instrument the application and their supporter adapters and entry points
When the project is instrumented by passing the flag `-m` or by running this task every new adapter will be generated
with instrumentation by default if supported.

The curren status of instrumentation

| Adapter               | Metrics | Traces |
|-----------------------|---------|--------|
| api_rest (*default*)  | ✔       | ✔      |
| asynceventhandler     | ✔       | ✘      |
| redis                 | ✔       | ✔      |
| asynceventbus         | ✔       | ✘      |
| x aws (*any request*) | ✔       | ✔      |
| repository            | ✔       | ✔      |
| restconsumer          | ✔       | ✔      |


#### Distillery

Creates distillery configuration for the clean architecture project.

It generates the next project files:

```
rel
├── plugins
|   └── .gitignore
└── config.exs
```

It also injects the *rel/config.exs* file with the next config_providers for prod env

```elixir
set config_providers: [{Distillery.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}] # Use config file at runtime
```

### Sonar

If you are using sonar, you can autogenerate the configuration files, these files will help you to:
- generate sobelow report through `mix sobelow -f json --out sobelow.json`
- generate test execution for sonarqube through `mix coveralls.xml`
- generate credo report for sonarqube through `mix credo --sonarqube-base-folder ./ --sonarqube-file credo_sonarqube.json`

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

