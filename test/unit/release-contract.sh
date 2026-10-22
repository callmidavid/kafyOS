#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
migrate="$project_dir/install/system/usr/local/bin/kafy-migrate"
recover="$project_dir/install/system/usr/local/bin/kafy-recover"
update="$project_dir/install/system/usr/local/bin/kafy-update"
provisioner="$project_dir/install/system/usr/local/lib/kafy/install/provision-target"
migrations_readme="$project_dir/migrations/README.md"

for command in "$migrate" "$recover" "$update"; do
  [[ -x $command ]] || {
    printf 'Release command is not executable: %s\n' "$command" >&2
    exit 1
  }
  bash -n "$command"
done

rg -Fq 'find "$migration_dir"' "$migrate"
rg -Fq 'KAFY_MIGRATION_ID' "$migrate"
rg -Fq 'pacman -Qk --quiet' "$recover"
rg -Fq 'pacman -Syu' "$update"
rg -Fq '/usr/local/bin/kafy-migrate' "$update"
rg -Fq 'kafy-migrate' "$provisioner"
rg -Fq 'kafy-recover' "$provisioner"
rg -Fq 'kafy-update' "$provisioner"
rg -Fq '/usr/lib/kafy/migrations' "$migrations_readme"

printf 'Kafy release contract passed.\n'
