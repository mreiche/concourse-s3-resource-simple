#!/bin/sh

exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging

set -e
cwd=$(dirname $0)
source "${cwd}/../assets/common.sh"

emit_version >&3
