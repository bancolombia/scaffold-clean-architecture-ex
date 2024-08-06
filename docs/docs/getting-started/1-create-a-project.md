---
sidebar_position: 1
---

# Create a Project

```
Creates a new Clean architecture scaffold

    $ mix ca.new.structure [application_name]
    $ mix ca.new.structure [application_name] --metrics --sonar --monorepo
    $ mix ca.new.structure [application_name] -m -s -r
```

## Creating a new project


The `ca.new.structure` task will generate a clean architecture structure in your project.

### Options

- `--metrics` or `-m`: this option will create a basic setup for metrics, this can be done after project creation too, by executing `mix ca.apply.config -t metrics`
- `--sonar` or `-s`: this option will create a basic setup for sonar reports, this can be done after project creation too, by executing `mix ca.apply.config -t sonar`
- `--monorepo` or `-r`: this option will create a basic set some paths relative to project name.

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
│       ├── custom_telemetry.ex # if --metrics enabled
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