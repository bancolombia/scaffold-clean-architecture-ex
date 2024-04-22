---
sidebar_position: 3
---

# Create a Driven Adapter

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