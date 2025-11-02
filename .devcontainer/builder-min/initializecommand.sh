#!/bin/sh

set -e

# assume it is running in repository's root directory
if [ ! -d "../kitchen" ]; then
  (OPWD=$PWD && cd .. &&  $OPWD/.devcontainer/scripts/init-kitchen.sh)
fi