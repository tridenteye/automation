export DOCKER_BUILDKIT=1

# Docker client
DOCKER := $(shell which docker 2>/dev/null)

.PHONY : docker-check docker-login docker-build docker-push docker-build-push docker_manifest
docker-check:
	$(call assert_set,DOCKER)
	@[ -x $(DOCKER) ] || (echo "$(DOCKER) not executable"; exit 1)

docker-login: docker-check
	@$(call assert_set,DOCKER_USERNAME)
	@$(call assert_set,DOCKER_PASSWORD)

	@echo "INFO: Logging into $(DOCKER_REGISTRY) as $(DOCKER_USERNAME)"

	@echo "$(DOCKER_PASSWORD)" | docker login $(DOCKER_REGISTRY) -u "$(DOCKER_USERNAME)" --password-stdin

## Build
# Generate build arguments list
BUILD_ARGS_ALL := $(foreach arg,$(BUILD_ARGS),--build-arg $(arg))
BUILD_TARGET := $(if $(STAGE_TO_BUILD),--target $(STAGE_TO_BUILD))
BUILD_SECRET_ALL := $(foreach sec,$(BUILD_SECRETS),--secret id=$(sec),env=$(sec))
docker-build:
# DOCKER_IMAG: image name with full path, PR_IMAGE and RELEASE_IMAGE
	@$(call assert_set,DOCKERFILE)
	@$(call assert_set,DOCKER_IMAGE)
	docker build --no-cache $(BUILD_SECRET_ALL) $(BUILD_TARGET) $(BUILD_ARGS_ALL) \
	-f $(DOCKERFILE) \
	-t $(DOCKER_IMAGE):$(TAG_ARCH) .

## Push
docker-push: $(TAG_TO_PUSH)
$(TAG_TO_PUSH):
	@$(call assert_set,DOCKER_IMAGE)
	docker tag $(DOCKER_IMAGE):$(TAG_ARCH) $(DOCKER_IMAGE):$@
	docker push $(DOCKER_IMAGE):$@

docker-buildx:
	docker buildx build \
	--progress auto \
	--platform linux/amd64,linux/ppc64le,linux/s390x \
	-t "${DOCKER_IMAGE}:$(TAG)" \
	-f ${DOCKERFILE} \
	. --load

## Manifest
# Generate image references for each platform
IMAGE_REFS := $(foreach platform,$(PLATFORMS),$(DOCKER_IMAGE):$(TAG_MANIFEST)-$(platform))
docker-manifest: $(TAG_MANIFEST_TO_PUSH)
$(TAG_MANIFEST_TO_PUSH):
	echo ############### Building image fat manifest: $(DOCKER_IMAGE):$@ ###############
	docker manifest create $(DOCKER_IMAGE):$@ -a $(IMAGE_REFS)
	docker manifest push $(DOCKER_IMAGE):$@

## Install the buildkit if not available
BUILDX_VERSION := v0.13.1
install-buildx:
	mkdir -p $(HOME)/.docker/cli-plugins
	wget https://github.com/docker/buildx/releases/download/$(BUILDX_VERSION)/buildx-$(BUILDX_VERSION).linux-amd64 -O buildx
	chmod +x buildx
	mv buildx $(HOME)/.docker/cli-plugins/docker-buildx