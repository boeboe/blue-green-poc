# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help clean package run-local test-local docker-build run-docker stop-docker test-docker

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## Clean the project by removing target folder
	mvn clean

package: ## Package the project into a JAR file
	mvn clean package

run-local: ## Run the Spring Boot application locally from JAR
	mvn spring-boot:run -P run-local

test-local: ## Run integration tests against local Spring Boot app
	mvn test -Dapi.base.url=http://localhost -Dapi.port=8080

docker-build: ## Build multi-platform Docker image
	mvn clean package -DskipTests
	docker buildx build --platform linux/amd64,linux/arm64 --push -t boeboe/message-service:latest .

run-docker: ## Run the Docker image locally on port 8080
	docker run -d --name message-service -p 8080:8080 boeboe/message-service:latest

stop-docker: ## Stop and remove the running Docker container
	docker stop message-service && docker rm message-service

test-docker: run-docker ## Run integration tests against the running Dockerized app
	@DOCKER_HOST_IP=$(shell docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' message-service) || { echo "Docker container not running. Exiting."; exit 1; } && \
	echo "Running tests against Docker host at $$DOCKER_HOST_IP" && \
	BASE_URL="http://$$DOCKER_HOST_IP" PORT=8080 ./test.sh || { echo "Tests failed. Stopping Docker container."; $(MAKE) stop-docker; exit 1; }
	$(MAKE) stop-docker