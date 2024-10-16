# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help install build serve test clean docker-build docker-run docker-stop docker-clean

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

DOCKER_REGISTRY=boeboe
DOCKER_IMAGE=message-frontend
VERSION=1.0.0
CONTAINER_PORT=80

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

docker-build: ## Build the Docker image
	@echo "Building the Docker image..."
	docker buildx build --platform linux/amd64,linux/arm64 --push -t $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION) .

docker-run: ## Run the Docker container
	@echo "Running Docker container '$(DOCKER_IMAGE)'..."
	@if [ "$(shell docker ps -q -f name=$(DOCKER_IMAGE))" ]; then \
		echo "Docker container '$(DOCKER_IMAGE)' is already running."; \
	else \
		if [ "$(shell docker ps -a -q -f name=$(DOCKER_IMAGE))" ]; then \
			echo "Starting existing container '$(DOCKER_IMAGE)'..."; \
			docker start $(DOCKER_IMAGE); \
		else \
			echo "Starting new Docker container '$(DOCKER_IMAGE)'..."; \
			docker run -d -p 8080:$(CONTAINER_PORT) --name $(DOCKER_IMAGE) -e BACKEND_URL=http://message-service $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION); \
		fi \
	fi

docker-stop: ## Stop and remove the Docker container
	@echo "Stopping Docker container '$(DOCKER_IMAGE)'..."
	@if [ "$(shell docker ps -q -f name=$(DOCKER_IMAGE))" ]; then \
		echo "Stopping and removing running container '$(DOCKER_IMAGE)'..."; \
		docker stop $(DOCKER_IMAGE) && docker rm $(DOCKER_IMAGE); \
	else \
		if [ "$(shell docker ps -a -q -f name=$(DOCKER_IMAGE))" ]; then \
			echo "Removing stopped container '$(DOCKER_IMAGE)'..."; \
			docker rm $(DOCKER_IMAGE); \
		else \
			echo "Docker container '$(DOCKER_IMAGE)' is not running."; \
		fi \
	fi

docker-clean: ## Clean up old Docker images
	@echo "Cleaning up old Docker images..."
	@if [ "$(shell docker ps -a -q -f ancestor=$(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION))" ]; then \
		echo "Forcing removal of the container..."; \
		docker rm -f $(shell docker ps -a -q -f ancestor=$(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION)); \
	fi
	docker rmi -f $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION) || true