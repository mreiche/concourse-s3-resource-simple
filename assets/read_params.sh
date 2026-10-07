#!/usr/bin/env bash

payload=`cat`
bucket=$(get_bucket)
prefix=$(get_prefix)
aws_options=$(echo "$payload" | jq -r '.source.aws_options // [] | join(" ")')
options=$(echo "$payload" | jq -r '.params.options // [] | join(" ")')
skip_download=$(echo "$payload" | jq -r '.params.skip_download // false')
copy=$(echo "$payload" | jq -r '.params.copy // false')
source_dir=$(echo "$payload" | jq -r '.params.source_dir // "."')
bucket_uri="s3://${bucket}/${prefix}"

if [ "${copy}" == "true" ]; then
  command="cp --recursive"
else
  command="sync"
fi
