INDEX_FILE_PATH = docs/index.adoc
IMAGE_NAME = yiwkr/asciidoctor
.DEFAULT_GOAL = help

.PHONY: html
html: build-docker-image ## build html
	@docker run --rm -it \
		-v $(shell pwd):/data \
		--workdir /data \
		$(IMAGE_NAME) \
		asciidoctor \
		-a stylesheets=../styles/custom.css \
		-r asciidoctor-diagram \
		-D build \
		$(INDEX_FILE_PATH)
	@echo "html has been built successfully"

.PHONY: pdf
pdf: build-docker-image ## build pdf
	@docker run --rm -it \
		-v $(shell pwd):/data \
		--workdir /data \
		$(IMAGE_NAME) \
		asciidoctor-pdf \
		-a scripts=cjk \
		-a pdf-theme=custom \
		-a pdf-themesdir=themes \
		-r asciidoctor-diagram \
		-D build \
		$(INDEX_FILE_PATH)
	@echo "pdf has been built successfully"

.PHONY: build
build: html pdf ## build html and pdf

.PHONY: build-docker-image
build-docker-image: ## build docker image
	@docker build -t $(IMAGE_NAME) . > /dev/null
	@echo "docker image has been built successfully"

.PHONY: run
run: build-docker-image ## run bash on docker docker
	@docker run --rm -it \
		-v $(shell pwd):/data \
		--workdir /data \
		$(IMAGE_NAME) \
		bash

.PHONY: serve
serve: build-docker-image ## run http serve
	@docker run --rm -it \
		-v $(shell pwd):/data \
		--workdir /data \
		-p $${PORT:-8080}:8080 \
		$(IMAGE_NAME) \
		ruby -run -e httpd .

.PHONY: help
help:
	@grep -E '^[A-Za-z_-]*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf  "\033[36m%-20s\033[0m %s\n", $$1, $$2}'