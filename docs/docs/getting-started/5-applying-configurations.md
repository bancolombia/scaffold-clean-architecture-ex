---
sidebar_position: 5
---

# Applying configurations

Applies a configuration for the clean architecture project

```bash
 mix ca.apply.config -t <config_type>
```

Type param options:

| Name       | Description                                                 |
|------------|-------------------------------------------------------------|
| metrics    | Add metrics setup for adapters and exporter                 |
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

### Sonar

If you are using sonar, you can autogenerate the configuration files, these files will help you to:
- generate sobelow report through `mix sobelow -f json --out _build/release/sobelow.json`
- generate test execution for sonarqube through `mix coveralls.xml`
- generate credo report for sonarqube through `mix credo --sonarqube-base-folder ./ --sonarqube-file _build/release/credo_sonarqube.json`