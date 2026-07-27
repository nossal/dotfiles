#!/usr/bin/env bash
set -uo pipefail

repo_dir="$(git rev-parse --show-toplevel)"
eval "$HOME/.local/share/mise/shims/lazygit -p $repo_dir"

