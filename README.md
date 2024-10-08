# Blue Green POC

## Overview

This project provides a Proof of Concept (PoC) for blue green deployments for REST and Event/Command based microservices.

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
```
