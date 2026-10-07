# Simple S3 Resource for [Concourse CI](http://concourse.ci)

Resource to upload files to S3. Unlike the [the official S3 Resource](https://github.com/concourse/s3-resource), this Resource can upload or download multiple files.

## Usage

```yaml
resource_types:
- name: s3-bucket
  type: registry-image
  source:
    repository: ghcr.io/mreiche/concourse-s3-resource-simple
    tag: latest

resources:
- name: s3
  type: s3-bucket
  source:
    uri: https://objects-us-east-1.dream.io
    bucket: my-bucket
    access_key_id: ((aws_access_key)) # Optional
    secret_access_key: ((aws_secret_key)) # Optional
    options: []  # Optional
    debug: false  # Optional
    prefix: my-prefix # Optional

jobs:
  - name: publish-files
    plan:
      - get: s3
        params: 
          prefix: my-prefix # Optional
          options: []  # Optional
          copy: false  # Optional

      - task: "do-something"
        inputs:
          - name: s3
            path: local-folder
        outputs:
          - name: local-folder
      
      - put: s3
        no_get: true
        inputs:
          - local-folder
        params:
          source_dir: local-folder
          prefix: my-prefix # Optional
          copy: false  # Optional
          options: []  # Optional
```

### Prefix

Use `prefix` to get or put files as path below the bucket. It's built like `${source.bucket}/${source.prefix}${params.prefix}`.

### Options

Set any option of the RustFS CLI (https://github.com/rustfs/cli/blob/main/docs/reference/rc/cp.md), where `source.options` go first, followed by `params.options`.

### Change detection

This resource creates a file `${source.bucket}/${source.prefix}/_last_modified` with the current Unix timestamp to detect changes between `put` and `check`.