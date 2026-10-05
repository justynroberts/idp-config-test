IMAGE ?= ghcr.io/justynroberts/idp:latest

.PHONY: help validate schema
help: ## Show targets
	@grep -E '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

validate: ## Check every document the way the portal will (exit 1 on errors)
	docker run --rm -v "$(CURDIR):/config:ro" $(IMAGE) validate /config

schema: ## Refresh schema/idp.schema.json from the portal image
	docker run --rm $(IMAGE) schema > schema/idp.schema.json
