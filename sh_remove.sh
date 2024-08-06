#!/bin/bash
version=$(grep -o '@version "[^"]*' "mix.exs" | sed 's/@version "//')
echo "Uninstalling Elixir Structure Manager $version"
mix archive.uninstall elixir_structure_manager-$version --force
