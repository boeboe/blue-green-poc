# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help clean package run-local test-local docker-build docker-run docker-stop docker-clean docker-test check-updates generate-openapi

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

DOCKER_REGISTRY=boeboe
DOCKER_IMAGE=message-backend
VERSION=1.0.0
CONTAINER_PORT=80

clean: ## Clean the project by removing target folder
	@echo "Cleaning the project..."
	mvn clean

package: ## Package the project into a JAR file
	@echo "Packaging the project into a JAR file..."
	mvn clean package -U

run-local: ## Run the Spring Boot application locally from JAR
	@echo "Running Spring Boot application locally..."
	mvn spring-boot:run

test-local: ## Run integration tests against local Spring Boot app
	@echo "Running integration tests against local Spring Boot app..."
	mvn test -Dapi.base.url=http://localhost -Dapi.port=8080

docker-build: ## Build multi-platform Docker image
	@echo "Building Docker image..."
	mvn clean package -DskipTests
	docker buildx build --platform linux/amd64,linux/arm64 --push -t $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION) .

docker-run: docker-build ## Run the Docker image locally on port 8080
	@echo "Running Docker container 'message-service'..."
	@if [ "$(shell docker ps -q -f name=message-service)" ]; then \
		echo "Docker container 'message-service' is already running."; \
	else \
		echo "Starting Docker container 'message-service'..."; \
		docker run -d --name message-service -p 8080:$(CONTAINER_PORT) $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):latest; \
	fi

docker-stop: ## Stop and remove the running Docker container
	@echo "Stopping Docker container 'message-service'..."
	@if [ "$(shell docker ps -q -f name=message-service)" ]; then \
		echo "Stopping and removing Docker container 'message-service'..."; \
		docker stop message-service && docker rm message-service; \
	else \
		if [ "$(shell docker ps -a -q -f name=message-service)" ]; then \
			echo "Removing stopped Docker container 'message-service'..."; \
			docker rm message-service; \
		else \
			echo "Docker container 'message-service' is not running."; \
		fi \
	fi

docker-clean: ## Clean up old Docker images
	@echo "Cleaning up old Docker images..."
	@if [ "$(shell docker ps -a -q -f ancestor=$(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION))" ]; then \
		echo "Forcing removal of the container..."; \
		docker rm -f $(shell docker ps -a -q -f ancestor=$(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION)); \
	fi
	docker rmi -f $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(VERSION) || true

docker-test: docker-run ## Run integration tests against the running Dockerized app
	@echo "Running integration tests against Dockerized app..."
	./test.sh
	$(MAKE) docker-stop

check-updates: ## Check for maven dependency updates
	@echo "Checking for maven dependency updates..."
	mvn versions:display-dependency-updates
	mvn versions:display-plugin-updates

generate-openapi: ## Start Spring Boot, generate OpenAPI spec, then stop Spring Boot
	@echo "Starting Spring Boot application..."
	mvn spring-boot:run &
	@echo "Waiting for Spring Boot app to start..."
	sleep 10  # Optional: Adjust if needed for the app to fully start
	@echo "Generating OpenAPI Spec..."
	mvn springdoc-openapi:generate
	@echo "Stopping Spring Boot application..."
	mvn spring-boot:stop
	@echo "Done."