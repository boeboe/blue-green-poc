# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help clean package run-local test-local docker-build run-docker stop-docker test-docker check-updates generate-openapi

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

clean: ## Clean the project by removing target folder
	mvn clean

package: ## Package the project into a JAR file
	mvn clean package -U

run-local: ## Run the Spring Boot application locally from JAR
	mvn spring-boot:run

test-local: ## Run integration tests against local Spring Boot app
	mvn test -Dapi.base.url=http://localhost -Dapi.port=8080

docker-build: ## Build multi-platform Docker image
	mvn clean package -DskipTests
	docker buildx build --platform linux/amd64,linux/arm64 --push -t boeboe/message-service:latest .

run-docker: docker-build ## Run the Docker image locally on port 8080
	@if [ "$(shell docker ps -q -f name=message-service)" ]; then \
		echo "Docker container 'message-service' is already running."; \
	else \
		echo "Starting Docker container 'message-service'..."; \
		docker run -d --name message-service -p 8080:8080 boeboe/message-service:latest; \
	fi

stop-docker: ## Stop and remove the running Docker container
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

test-docker: run-docker ## Run integration tests against the running Dockerized app
	./test.sh
	$(MAKE) stop-docker

check-updates: ## Check for maven dependency updates
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