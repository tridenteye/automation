# Docker Build and Push Makefile

This Makefile facilitates building Docker images, tagging them appropriately, and pushing them to a Docker registry. It also supports creating Docker manifest lists for multi-platform images.

## Prerequisites

- **Docker**: Ensure Docker is installed and configured on your system.
- **Docker Registry Credentials**: Provide Docker registry credentials via environment variables `DOCKER_USERNAME` and `DOCKER_PASSWORD`.
- **Build Dependencies**: Ensure all necessary dependencies are available to build the Docker image.

## Usage

1. **Set Environment Variables**: Update the necessary environment variables in the Makefile or provide them via command-line arguments.

2. **Execute Make Commands**: Run the desired Make commands to perform Docker build, push, or manifest creation operations.

   ```bash
   make docker-build          # Build Docker image
   make docker-push           # Push Docker image
   make docker-manifest       # Create Docker manifest
   ```

## Available Targets

- **docker-build**: Build the Docker image using the specified Dockerfile, tag it with appropriate version tags, and create the image locally.
- **docker-push**: Tag the Docker image with version tags and push them to the Docker registry.
- **docker-manifest**: Create a Docker manifest list for multi-platform images and push it to the Docker registry.

## Environment Variables

- **DOCKER_REGISTRY**: Docker registry to push the images to. Default is `ghcr.io`.
- **NAMESPACE**: Namespace or organization on the Docker registry. Default is `bhavya`.
- **REGISTRY_DIR**: Directory within the namespace where the image will be stored. Default is `findout`.
- **DOCKER_USERNAME**: Docker registry username for authentication.
- **DOCKER_PASSWORD**: Docker registry password for authentication.
- **DOCKERFILE**: Path to the Dockerfile used for building the image.
- **IMAGE_NAME**: Name of the Docker image.
- **BRANCH**: Git branch name. Default is `unreleased-main`.
- **IMAGE_TAG**: Tag to be appended to the Docker image. Default is `latest`.
- **BUILD_ARGS**: Additional build arguments to be passed to `docker build`.
- **STAGE_TO_BUILD**: Target stage to build in the Dockerfile.
- **BUILD_SECRETS**: List of secret environment variables to be passed during build.

## Important Notes

- **Customization**: Review and customize the Makefile according to your project's requirements, such as Docker registry, namespace, Dockerfile path, etc.
- **Security**: Ensure that sensitive information such as Docker registry credentials and secrets are managed securely and are not hardcoded directly into the Makefile.
- **Testing**: Test the Makefile in a controlled environment to ensure it behaves as expected before using it in production.
- **Documentation**: Maintain clear documentation for each target and variable used in the Makefile to aid in understanding and usage.

## Disclaimer

This Makefile comes with no warranties or guarantees. Use it at your own risk. Always review and understand the actions performed by the Makefile before execution.
