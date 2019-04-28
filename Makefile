SHELL=/bin/bash
.DEFAULT_GOAL := help

# https://gist.github.com/tadashi-aikawa/da73d277a3c1ec6767ed48d1335900f3
.PHONY: $(shell grep --no-filename -E '^[a-zA-Z0-9_-]+:' $(MAKEFILE_LIST) | sed 's/://')

# Macro definitions
define review
	docker run -it --rm -v $(PWD):/book -w /book/articles vvakame/review:3.1 /bin/bash -ci ${1}
endef

# Phony Targets
diff: ## Word diff
	git diff head --word-diff-regex=$$'[^\x80-\xbf][\x80-\xbf]*' --word-diff=color

pdf: ## Compile pdf
	$(call review,"review-preproc -r --tabwidth=2 *.re && review-pdfmaker config.yml")

epub: ## Compile epub
	$(call review,"review-preproc -r --tabwidth=2 *.re && review-epubmaker config.yml")

# https://postd.cc/auto-documented-makefile/
help: ## Show help
	@grep --no-filename -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-40s\033[0m %s\n", $$1, $$2}'
