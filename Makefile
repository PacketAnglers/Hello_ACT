.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build Configs with AVD
	ansible-playbook playbooks/build.yml

.PHONY: deploy
deploy: ## Deploy configs via eAPI
	ansible-playbook playbooks/deploy-eapi.yml -i remote-inventory.yml

.PHONY: deploy-cvp
deploy-cvp: ## Deploy configs via CVP
	ansible-playbook playbooks/deploy-cvp.yml
