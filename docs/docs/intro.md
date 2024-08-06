---
sidebar_position: 1
---

# ¿What is Elixir Structure Manager?

[![Build Status](https://github.com/bancolombia/scaffold-clean-architecture-ex/actions/workflows/main.yml/badge.svg)](https://github.com/bancolombia/scaffold-clean-architecture-ex/actions/workflows/main.yml) [![Hex.pm](https://img.shields.io/hexpm/v/elixir_structure_manager.svg)](https://hex.pm/packages/elixir_structure_manager) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/elixir_structure_manager/)
[![Coverage Status](https://coveralls.io/repos/github/bancolombia/scaffold-clean-architecture-ex/badge.svg?branch=main)](https://coveralls.io/bancolombia/scaffold-clean-architecture-ex?branch=main)

# Elixir Structure Manager

Elixir plugin to create an elixir application based on Clean Architecture following our best practices.

## Install

[HexDocs](https://hex.pm/packages/elixir_structure_manager)

```bash
mix archive.install hex elixir_structure_manager <version>
```

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