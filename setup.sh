#!/usr/bin/env bash
set -euo pipefail

# Dispatch to OS‑specific bootstrap
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$SCRIPT_DIR/setup/bootstrap.sh"
