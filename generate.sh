#!/usr/bin/env sh
#
# Copyright 2021 Zenauth Ltd.

set -euo pipefail

CERBOS_MODULE=${CERBOS_MODULE:-"buf.build/cerbos/cerbos-api"}

echo "Downloading sources"
buf mod update
buf export $CERBOS_MODULE -o /source

if [[ $# -gt 0 ]]; then
    buf $@
else
    buf generate --template /work/buf.gen.yaml --include-imports /source
fi
