# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

#################
##### Setup #####
#################

.PHONY: up-kind install-istio up down monitoring info reset clean docker-build docker-compose-up docker-compose-down docker-compose-restart docker-clean

reset: down up ## Reset the kind cluster and Istio installation
up: up-kind install-istio ## Spin up a kind cluster and install/upgrade Istio

up-kind: ## Spin up a kind cluster
	./up-kind.sh

install-istio: ## Install/upgrade Istio using Helm with NodePort for ingress gateway
	./install-istio.sh

down: ## Destroy the kind cluster
	./down.sh

monitoring: ## Install Prometheus and Grafana using Helm
	./monitoring.sh

info: ## Print kind cluster information and kubectl info
	./info.sh

clean: ## Clean all temporary artifacts
	rm -rf ./output/*

#####################
##### Services ######
#####################

DOCKER_REGISTRY=boeboe
VERSION=1.0.0
PLATFORMS=linux/amd64,linux/arm64  # Multi-platform target

docker-build: ## Build both front-end and back-end Docker images with multi-platform support
	@echo "Building Docker images for front-end and back-end with multi-platform support..."
	docker buildx build --platform $(PLATFORMS) --push -t $(DOCKER_REGISTRY)/message-frontend:$(VERSION) ./services/msg-sender-frontend
	docker buildx build --platform $(PLATFORMS) --push -t $(DOCKER_REGISTRY)/message-backend:$(VERSION) ./services/msg-sender-backend

docker-compose-up: ## Start both front-end and back-end using Docker Compose
	@echo "Starting front-end and back-end services with Docker Compose..."
	docker-compose up -d

docker-compose-down: ## Stop the Docker Compose services
	@echo "Stopping Docker Compose services..."
	docker-compose down

docker-compose-restart: ## Restart Docker Compose services
	@echo "Restarting Docker Compose services..."
	docker-compose down
	docker-compose up -d

docker-clean: ## Clean up Docker resources
	@echo "Cleaning up Docker images and containers..."
	docker-compose down --rmi all

