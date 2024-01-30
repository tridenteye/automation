#!/bin/bash
set -eu
SCRIPT_PATH="$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"
IFS=$' \t\r\n'

# Set your source and destination registry information

image_name="golang:1.21.5"

source_registry="docker.io"
source_image="library/${image_name}"
source_registry_user=""
source_registry_pass=""

destination_registry=""
destination_image="local-docker/subfolder/${image_name}"
destination_registry_user=""
destination_registry_pass=""

skopeo-login()  {
    echo "Logging in to: ${REGISTRY} "
    echo "${REGISTRY_PASS} | "skopeo login -u ${REGISTRY_USER} --password-stdin
}

image-copy() {
    # Perform the image copy
    source_image_full="${source_registry}/${source_image}"
    destination_image_full="${destination_registry}/${destination_image}"

    echo "Copying image from ${source_image_full} -t---o> ${destination_image_full}"
    skopeo copy "docker://${source_image_full}" "docker://${destination_image_full}" || { echo "Failed to copy image"; exit 1; }

    echo "Image copy completed!"
}

image-copy-e2e() {
    # "Logging into source registry : ${source_registry}..."
    REGISTRY="${source_registry}" \
    REGISTRY_USER="${source_registry_user}" \
    REGISTRY_PASS="${source_registry_pass}" \
    skopeo-login

    # "Logging into destination registry : ${destination_registry}..."
    REGISTRY="${destination_registry}" \
    REGISTRY_USER="${destination_registry_user}" \
    REGISTRY_PASS="${destination_registry_pass}" \
    skopeo-login

    image-copy

    # Logout from both registries
    echo "Logging out from both registries..."
    docker logout ${source_registry}
    docker logout ${destination_registry}
}