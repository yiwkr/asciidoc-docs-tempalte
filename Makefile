
ASCIIDOCTOR_HTML := asciidoctor -a stylesheet=../styles/custom.css -r asciidoctor-diagram
ASCIIDOCTOR_PDF := asciidoctor-pdf -a scripts=cjk -a pdf-themesdir=themes -r asciidoctor-diagram -r ./themes/patch.rb
DOCKER := $(shell command -v docker)
DOCKER_RUN := $(DOCKER) run --rm -it -v $(shell pwd):/work --workdir /work
IMAGE_NAME := yiwkr/docker-asciidoctor
INPUT_DIR := docs
OUTPUT_DIR := build/docs
CLEAN_COMMAND := sh -c "git clean -xdf"
WEB_SERVER_PORT := 8080
WEB_SERVER_COMMAND := ruby -run -e httpd -- --port=$(WEB_SERVER_PORT) $(OUTPUT_DIR)

.DEFAULT_GOAL := help

.PHONY: clean
clean: ## cleanup build directory
ifneq ($(DOCKER),)
	@$(DOCKER_RUN) $(IMAGE_NAME) $(CLEAN_COMMAND)

else
	@$(CLEAN_COMMAND)
endif

.PHONY: docker-image
docker-image: ## build docker image
ifneq ($(DOCKER),)
	@docker build -t $(IMAGE_NAME) . > /dev/null
endif

.PHONY: html
html: docker-image ## build html
	@echo -n "building html ... "
ifneq ($(DOCKER),)
	@$(DOCKER_RUN) $(IMAGE_NAME) $(ASCIIDOCTOR_HTML) -D $(OUTPUT_DIR) $(INPUT_DIR)/*.adoc
else
	@$(ASCIIDOCTOR_HTML) -D $(OUTPUT_DIR) $(INPUT_DIR)/*.adoc
endif
	@echo "done"

.PHONY: pdf
pdf: docker-image ## build pdf
	@echo -n "building pdf ... "
ifneq ($(DOCKER),)
	@$(DOCKER_RUN) $(IMAGE_NAME) $(ASCIIDOCTOR_PDF) -D $(OUTPUT_DIR) $(INPUT_DIR)/*.adoc
else
	@$(ASCIIDOCTOR_PDF) -D $(OUTPUT_DIR) $(INPUT_DIR)/*.adoc
endif
	@echo "done"

.PHONY: bash
ifneq ($(DOCKER),)
bash: docker-image ## run bash on docker container
	@$(DOCKER_RUN) $(IMAGE_NAME) \
		bash
endif

.PHONY: serve
serve: docker-image ## run http server
ifneq ($(DOCKER),)
	@$(DOCKER_RUN) -p $(WEB_SERVER_PORT):$(WEB_SERVER_PORT) $(IMAGE_NAME) $(WEB_SERVER_COMMAND)
else
	@$(WEB_SERVER_COMMAND)
endif

.PHONY: build
build: html pdf ## build html and pdf

.PHONY: live-build
live-build: ## automatically build html and pdf when files are changed
	@find docs styles themes | entr $(MAKE) build

.PHONY: help
help:
	@grep -E '^[A-Za-z_-]*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf  "\033[36m%-20s\033[0m %s\n", $$1, $$2}' | sort