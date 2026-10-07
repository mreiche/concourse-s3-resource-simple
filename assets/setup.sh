#!/usr/bin/env bash

get_uri() {
  local uri=$(echo "$payload" | jq -r '.source.uri')
  test -z "${uri}" && { echo "Must supply source.uri" >&2; exit 1; }
  echo ${uri}
}

get_bucket() {
  local bucket=$(echo "$payload" | jq -r '.source.bucket')
  test -z "$bucket" && { echo "Must supply source.bucket" >&2; exit 1; }
  echo $bucket
}

get_last_modified() {
  if rc get "local/${bucket}/${global_prefix:+${global_prefix}/}_last_modified" /tmp/_last_modified --quiet >&2; then
    cat /tmp/_last_modified
  else
    echo
  fi
}

payload=`cat`
bucket=$(get_bucket)
uri=$(get_uri)
local_prefix=$(echo "$payload" | jq -r '.params.prefix // ""')
global_prefix=$(echo "$payload" | jq -r '.source.prefix // ""')
prefix="${global_prefix}${local_prefix}"
debug=$(echo "$payload" | jq -r '.source.debug // empty')
access_key_id=$(echo "$payload" | jq -r '.source.access_key_id // empty')
secret_access_key=$(echo "$payload" | jq -r '.source.secret_access_key // empty')
global_options=$(echo "$payload" | jq -r '.source.options // [] | join(" ")')
local_options=$(echo "$payload" | jq -r '.params.options // [] | join(" ")')
copy=$(echo "$payload" | jq -r '.params.copy // false')
source_dir=$(echo "$payload" | jq -r '.params.source_dir // "."')

if [ "${copy}" == "true" ]; then
  command="cp -r"
else
  command="mirror"
fi

rc alias set local "${uri}" "${access_key_id}" "${secret_access_key}"

if [ "${debug}" == "true" ]; then
  set -x
fi
