DOCKER_REGISTRY := 
NAMESPACE := 
REGISTRY_DIR := 

IMAGE_NAME := 
STAGE_TO_BUILD := prod

include make-tools/docker.var.mk
include make-tools/docker.mk

$(info TAG_MANIFEST_TO_PUSH = $(TAG_MANIFEST_TO_PUSH))