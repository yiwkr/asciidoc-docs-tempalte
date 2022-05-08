INDEX_FILE_PATH = docs/index.adoc
IMAGE_NAME = yiwkr/asciidoctor
.DEFAULT_GOAL = help

.PHONY: html
html: ## build html
	@asciidoctor \
		-r asciidoctor-diagram \
		-D build \
		$(INDEX_FILE_PATH)

.PHONY: pdf
pdf: ## build pdf
	@asciidoctor-pdf \
		-a scripts=cjk \
		-a pdf-theme=default-with-fallback-font \
		-r asciidoctor-diagram \
		-D build \
		$(INDEX_FILE_PATH)

.PHONY: build-image
build-image: ## build docker image
	@docker build -t $(IMAGE_NAME) .

.PHONY: run
run: build-image ## run bash on docker container
	@docker run --rm -it \
		-v $(shell pwd):/data \
		--workdir /data \
		$(IMAGE_NAME) \
		bash

.PHONY: build
build: html pdf ## build all

.PHONY: help
help:
	@grep -E '^[A-Za-z_-]*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf  "\033[36m%-20s\033[0m %s\n", $$1, $$2}'