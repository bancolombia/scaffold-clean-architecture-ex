#!/bin/bash
export MIX_ENV=prod
version=$(grep -o '@version "[^"]*' "mix.exs" | sed 's/@version "//')
echo "Installing Elixir Structure Manager $version"
mix do archive.build, archive.install --force
