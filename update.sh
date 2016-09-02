#!/bin/bash
set -eo pipefail

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

remoteVersions="$(wget -qO- https://pypi.python.org/pypi/celery/json | jq -r '.releases | keys | .[]')"

travisEnv=
for version in "${versions[@]}"; do
	current="$(echo "$remoteVersions" | grep -E '^'"$version" | sort -V | tail -1)"
	
	(
		set -x
		sed -r 's/^(ENV CELERY_VERSION) .*/\1 '"$current"'/' Dockerfile.template > "$version/Dockerfile"
	)
	
	travisEnv='\n  - VERSION='"$version$travisEnv"
done

travis="$(awk -v 'RS=\n\n' '$1 == "env:" { $0 = "env:'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
