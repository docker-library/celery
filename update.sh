#!/bin/bash
set -e

current="$(wget -qO- https://pypi.python.org/pypi/celery/json | jq -r '.releases | keys | .[]' | grep -v 'rc' | sort -V | tail -1)"

set -x
sed -ri 's/^(ENV CELERY_VERSION) .*/\1 '"$current"'/' Dockerfile
