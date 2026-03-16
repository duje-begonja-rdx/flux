DOCKERHUB_USER ?= kagunda
IMAGE_NAME ?= python-endpoint-counter
TAG ?= latest
IMAGE ?= $(DOCKERHUB_USER)/$(IMAGE_NAME):$(TAG)

.PHONY: build push rebuild

build:
	docker build -t $(IMAGE) .

push: build
	docker push $(IMAGE)

rebuild:
	docker build --no-cache -t $(IMAGE) .
