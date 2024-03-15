# Image Copy Script

This script facilitates the copying of Docker images from a source registry to a destination registry using Skopeo. It ensures seamless transfer of container images between different repositories.

## Prerequisites

- **Skopeo**: Ensure Skopeo is installed and available in your environment. Skopeo is a command-line utility that performs various operations on container images and image repositories.
- **Docker**: Docker must be installed to handle the login/logout operations with the registries.

## Usage

1. **Set Variables**: Before using the script, ensure that all necessary variables are correctly set. These variables include the source and destination registry details, image names, and credentials.

   ```bash
   export image_name="golang:1.21.5"
   export source_image="library/${image_name}"
   export source_registry="docker.io"
   export source_registry_user="your_source_registry_user"
   export source_registry_pass="your_source_registry_password"
   
   export destination_registry="your_destination_registry"
   export destination_image="local-docker/subfolder/${image_name}"
   export destination_registry_user="your_destination_registry_user"
   export destination_registry_pass="your_destination_registry_password"
   ```

2. **Execute the Script**: Run the script to initiate the image copying process.

   ```bash
   ./image_copy.sh
   ```

## Script Functions

- **skopeo-login**: This function logs in to the specified registry using Skopeo. It utilizes the provided credentials to authenticate the user.
- **image-copy**: Copies the Docker image from the source registry to the destination registry. It constructs the full image paths and executes the copying process using Skopeo.
- **image-copy-e2e**: Executes end-to-end image copying process, including logging in to both source and destination registries, copying the image, and logging out from both registries afterward.

## Important Notes

- Ensure that Skopeo is properly configured and accessible in your environment.
- It's recommended to securely manage your registry credentials and avoid hardcoding them directly into the script for enhanced security.
- Before running the script, make sure you have the necessary permissions to access the source and destination registries.

## Disclaimer

This script comes with no warranties or guarantees. Use it at your own risk. Always review and understand the actions performed by the script before execution.