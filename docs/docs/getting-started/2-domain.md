---
sidebar_position: 2
---

# Create Domain Modules

In the clean architecture aproaches there are different kind of modules, we define three:

## Models
A Model is an entity representation with a specific structure.

## Behaviours

A behavior can represent a port that will be implemented in any way to satisfy a domain need.

## UseCases

The usecases are the business logic which can use models and call the different behaviours.


# Generate a Model

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

# Generate an Use Case

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