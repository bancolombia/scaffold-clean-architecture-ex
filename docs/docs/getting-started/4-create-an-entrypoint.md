---
sidebar_position: 4
---

# Create an Entry Point

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