#!/usr/bin/env bash

# Check if the context exists
if ! kubectl config get-contexts "${KUBECONTEXT}" &>/dev/null; then
  print_error "Error: Kubernetes context '${KUBECONTEXT}' does not exist."
  exit 1
fi

# Get the current context
CURRENT_CONTEXT=$(kubectl config current-context)

# If the current context is not the target context, switch to it
if [ "${CURRENT_CONTEXT}" != "${KUBECONTEXT}" ]; then
  print_info "Switching to Kubernetes context '${KUBECONTEXT}'..."
  kubectl config use-context "${KUBECONTEXT}"
else
  print_info "Already using Kubernetes context '${KUBECONTEXT}'."
fi 
