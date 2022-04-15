#!/bin/sh
set -eu

script_dir="$(cd "$(dirname "$0")" && echo "$(pwd -P)/")"
repo_dir="$(dirname "$script_dir")"
cd "$repo_dir"

image_name="${1:-tezos_build_deps}"
image_version="${2:-latest}"
arch="${3:-x86_64}"
targetarch="${4:-amd64}"

"$script_dir"/create_docker_image.runtime-dependencies.sh \
             "$image_name" \
             "runtime-dependencies--$image_version"

"$script_dir"/create_docker_image.runtime-prebuild-dependencies.sh \
             "$image_name" \
             "runtime-prebuild-dependencies--$image_version" \
             "$image_name:runtime-dependencies--$image_version" \
             "$arch" \
             "$targetarch"

"$script_dir"/create_docker_image.runtime-build-dependencies.sh \
             "$image_name" \
             "runtime-build-dependencies--$image_version" \
             "$image_name:runtime-prebuild-dependencies--$image_version"

"$script_dir"/create_docker_image.runtime-build-test-dependencies.sh \
             "$image_name" \
             "runtime-build-test-dependencies--$image_version" \
             "$image_name:runtime-build-dependencies--$image_version"
