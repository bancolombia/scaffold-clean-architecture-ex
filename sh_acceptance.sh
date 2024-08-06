#!/bin/bash
bash sh_install.sh
mkdir -p _build
cd _build
rm -rf acceptance

mix ca.new.structure Acceptance -s -m -r --acceptance
cd acceptance

mix ca.new.model User -b

adapters=("asynceventbus" "dynamo" "generic" "redis" "repository" "restconsumer" "secrestsmanager")

for adapter in $adapters
do
  mix ca.new.da --type $adapter --name $adapter
done

entries=("asynceventhandler")

for entry in $entries
do
  mix ca.new.ep --type $entry --name $entry
done

mix test