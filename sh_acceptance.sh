#!/bin/bash
mix do archive.build, archive.install --force
mkdir -p _build
cd _build
rm -rf acceptance

mix ca.new.structure Acceptance -s -m -r --acceptance
cd acceptance

mix ca.new.model User -b

adapters=(asynceventbus dynamo generic redis repository restconsumer secrestsmanager)

for adapter in $adapters
do
  mix ca.new.da $adapter
done

entries=(asynceventhandler)

for entry in $entries
do
  mix ca.new.ep $entry
done

mix test