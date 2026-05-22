#!/bin/bash
export MIX_ENV=prod
version=$(grep -o '@version "[^"]*' "mix.exs" | sed 's/@version "//')
echo "Installing Elixir Structure Manager $version"
mix archive.build
mix archive.install --force
