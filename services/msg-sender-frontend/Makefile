# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help install build serve test clean

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install node modules
	@echo "Installing dependencies..."
	npm install

build: ## Build the Angular project
	@echo "Building the project..."
	npm run build

serve: ## Serve the project locally
	@echo "Serving the project on http://localhost:4200..."
	npm start

test: ## Run tests
	@echo "Running tests..."
	npm run test

clean: ## Clean the project
	@echo "Cleaning the project..."
	rm -rf dist