INDEX_FILE_PATH = docs/index.adoc
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

.PHONY: all
all: html pdf ## build all

.PHONY: help
help:
	@grep -E '^[A-Za-z_-]*:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf  "\033[36m%-20s\033[0m %s\n", $$1, $$2}'