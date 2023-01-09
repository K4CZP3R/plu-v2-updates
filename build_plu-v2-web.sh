#!/bin/sh

# If version is not specified, exit with error
if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

# If private key is not specified, exit with error
if [ -z "$2" ]; then
    echo "Usage: $0 <version> <private key>"
    exit 1
fi

PRIVATE_KEY=$2


# Get tauri version and save it to TAURI_VERSION

# Check if jq is installed, if not use python3
if command -v jq &> /dev/null
then
    TAURI_VERSION=$(jq -r '.package.version' ./plu-v2-web/src-tauri/tauri.conf.json)
else
    TAURI_VERSION=$(python3 -c "import json; print(json.load(open('./plu-v2-web/src-tauri/tauri.conf.json'))['package']['version'])")
fi

# Throw error if tauri version is not found
if [ -z "$TAURI_VERSION" ]; then
    echo "Could not find tauri version"
    exit 1
fi

# Throw error if tauri version is not equal to version
if [ "$TAURI_VERSION" != "$VERSION" ]; then
    echo "Tauri version ($TAURI_VERSION) is not equal to version ($VERSION)"
    exit 1
fi



DOCKER_BUILDKIT=1 docker build \
    --build-arg VERSION="$VERSION" \
    --build-arg PRIVATE_KEY="$PRIVATE_KEY" \
    --file plu-v2-web.Dockerfile \
    --output builds/plu-v2-web/$1 .


