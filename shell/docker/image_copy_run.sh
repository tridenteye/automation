#!/bin/bash
set -eu

# Variables
image_name="golang:1.22.0" # Go: golang:1.21.5, # gitlab: gitlab/gitlab-ce:12.3.5-ce.0
source_registry="docker.io"
source_image="library/${image_name}"
source_registry_user="bhavyabapna"
source_registry_pass=""

destination_registry=ghch.io
destination_image=bhavya/golang/${image_name}
destination_registry_user="bhavyabapna"
destination_registry_pass=""

# Import:
# Get the directory of the script
SCRIPT_PATH="$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"

# Source the Docker functions from a library
source "${SCRIPT_PATH}/copy-image.sh"

# Set the Internal Field Separator (IFS) to whitespace characters
IFS=$' \t\r\n'

echo "Provided argument: $1"

# Case statement to handle different command-line arguments
case "$1" in
    "skopeo-login")
        skopeo-login
        ;;
    "image-copy")
        image-copy
        ;;
    "image-copy-e2e")
        image-copy-e2e
        ;;
    *)
        echo "Usage: $0 {skopeo-login|image-copy|image-copy-e2e}"
        exit 1
        ;;
esac
