#!/bin/bash
set -e

current="$(curl -s https://pypi.python.org/pypi/celery/json | jq -r '.info.version')"

set -x
sed -i -e 's/^\(ENV CELERY_VERSION\) .*/\1 '"$current"'/' Dockerfile
