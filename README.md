# Blue Green POC

## Overview

This project provides a Proof of Concept (PoC) for blue green deployments of an application containing:
	- an angular frontend
	- a spring boot REST backend
	- event queues (WIP)

## Prerequisites

Ensure you have the following tools installed before proceeding:

	•	kubectl

## Usage

The following targets are defined in the [Makefile](./Makefile):

```console
$ make

help                           This help
reset                          Reset the kind cluster and Istio installation
up                             Spin up a kind cluster and install/upgrade Istio
up-kind                        Spin up a kind cluster
install-istio                  Install/upgrade Istio using Helm with NodePort for ingress gateway
down                           Destroy the kind cluster
monitoring                     Install Prometheus and Grafana using Helm
info                           Print kind cluster information and kubectl info
clean                          Clean all temporary artifacts
docker-build                   Build both front-end and back-end Docker images with multi-platform support
docker-compose-up              Start both front-end and back-end using Docker Compose
docker-compose-down            Stop the Docker Compose services
docker-compose-restart         Restart Docker Compose services
docker-clean                   Clean up Docker resources
```
