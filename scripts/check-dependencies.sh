#!/usr/bin/env bash
set -euo pipefail
for cmd in terraform ansible kubectl talosctl; do
    if ! command -v $cmd &> /dev/null; then
        echo "$cmd not found!"
        exit 1
    else
        echo "✓ $cmd"
    fi
done
