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

.PHONY: up-kind install-istio up down monitoring info reset clean

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

######################
##### Scenarios ######
######################


