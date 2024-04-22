---
sidebar_position: 1
---

# Create a Project

## Available Mix Tasks

```shell
mix help | grep "mix ca."
```

| Task                  | Description                                               |
|-----------------------|-----------------------------------------------------------|
| mix ca.new.structure  | Creates a new clean architecture application.             |
| mix ca.new.model      | Creates a new model with empty properties                 |
| mix ca.new.usecase    | Creates a new usecase                                     |
| mix ca.new.da         | Creates a new driven adapter                              |
| mix ca.new.ep         | Creates a new entry point                                 |
| mix ca.apply.config   | Applies some project configuration                        |
| mix ca.update         | Updates dependencies to latest stable version from hex.pm |

### Task detail

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
    $ mix ca.new.structure [application_name] --metrics --sonar
    $ mix ca.new.structure [application_name] -m -s
```

## Creating a new project


The `ca.new.structure` task will generate a clean architecture structure in your project.

```bash
mix ca.new.structure <project-name>

mix ca.new.structure <project-name> --metrics

mix ca.new.structure <project-name> -m
```

For example:

```shell
mix ca.new.structure app -m -s
```

**_The structure will look like this_**

```
app
├── config
│   ├── config.exs
│   ├── dev.exs
│   ├── prod.exs
│   └── test.exs
├── coveralls.json
├── lib
│   ├── application.ex
│   ├── config
│   │   ├── app_config.ex
│   │   └── config_holder.ex
│   ├── domain
│   │   ├── behaviours
│   │   ├── model
│   │   └── use_cases
│   ├── infrastructure
│   │   ├── driven_adapters
│   │   └── entry_points
│   │       ├── api_rest.ex
│   │       └── health_check.ex
│   └── utils
│       ├── custom_telemetry.ex
│       └── data_type_utils.ex
├── mix.exs
├── mix.lock
├── resources
│   └── cloud
│       ├── Dockerfile
│       └── Dockerfile-build
├── sh_build.sh
└── test
    ├── infrastructure
    │   └── entry_points
    │       └── api_rest_test.exs
    ├── app_application_test.exs
    ├── support
    │   └── test_stubs.exs
    └── test_helper.ex
```
Generated base applications comes with a REST Entry Point which listens on port 8083

After project generation you ca enter and run it

```shell
cd app
iex -S mix
```

Enter to [http://localohst:8083/api/health](http://localohst:8083/api/health) and your api will reply with:

```json
[
  {
    "error": null,
    "healthy": true,
    "name": "http",
    "time": 1
  }
]
```