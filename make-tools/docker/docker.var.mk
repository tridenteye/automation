# Variable
DOCKER_REGISTRY ?= ghcr.io
NAMESPACE ?= bhavya
REGISTRY_DIR ?= findout

DOCKER_USERNAME ?= 
DOCKER_PASSWORD ?=
DOCKERFILE ?= Dockerfile
IMAGE_NAME ?=

DOCKER_IMAGE 	:= $(DOCKER_REGISTRY)/${NAMESPACE}/${REGISTRY_DIR}/${IMAGE_NAME}

# Check if BRANCH starts with "release-"
ifeq ($(BRANCH),master)
    BRANCH := unreleased-main
endif

ifeq ($(BRANCH),main)
    BRANCH := unreleased-main
endif

ifneq ($(findstring release-,$(BRANCH)),)
    BRANCH := $(BRANCH:release-%=%)
endif


$(info BRANCH = $(BRANCH))


IMAGE_TAG ?= latest

GIT_COMMIT := $(shell git rev-parse --short HEAD)
BUILD_DATE := $(shell date +%Y%m%d)

# # Arguments passed to "docker build"
ARCH = $(shell uname -m)
# ifeq ($(ARCH),x86_64)
# 		ARCH := amd64
# endif

# Image tag for each platform
TAG_ARCH	:= $(BRANCH)-$(IMAGE_TAG)-$(ARCH)
TAG_RUNTIME := $(BRANCH)-$(GIT_COMMIT)-$(BUILD_DATE)-$(ARCH) # unreleased-main-5205cef-20230824, in case of PR:- PR26-5205cef-20230824

TAG_TO_PUSH ?= \
	$(TAG_ARCH) \
	$(TAG_RUNTIME)

### Variable for manifest
TAG_MANIFEST := $(BRANCH)-$(IMAGE_TAG)
TAG_MANIFEST_UNIQUE := $(BRANCH)-$(IMAGE_TAG)-$(BUILD_DATE)

TAG_MANIFEST_TO_PUSH ?= \
	$(TAG_MANIFEST) \
	$(TAG_MANIFEST_UNIQUE)

# List of platform to include in fat-manifest
PLATFORMS ?= \
	x86_64 \
	ppc64le \
	s390x

BUILD_ARGS ?=
# EG:
# BUILD_ARGS ?= \
# 	ARG1=value1 \
# 	ARG2=value2 \
# 	ARG3=value3

STAGE_TO_BUILD ?=

### Secrets will be picked from ENV variable
BUILD_SECRETS ?=
# Eg:
# BUILD_SECRETS := \
# 	ARTIFACTORY_USER \
# 	ARTIFACTORY_TOKEN