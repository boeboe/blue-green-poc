#!/usr/bin/env bash

# Configuration
PORT=${PORT:-8080}
BASE_URL="http://localhost"
API_URL="${BASE_URL}:${PORT}/api/v1/messages"
NUM_MESSAGES=${1:-10}  # Default to 10 messages
NUM_UPDATES=${2:-5}    # Default to 5 updates (can be overridden)

# Colors
end="\033[0m"
greenb="\033[1;32m"
lightblueb="\033[1;36m"
redb="\033[1;31m"
yellowb="\033[1;33m"

# Print info messages
function print_info {
  echo -e "${greenb}${1}${end}"
}

# Print error messages
function print_error {
  echo -e "${redb}${1}${end}"
}

# Helper function for making requests
function curl_request() {
  curl -s -o /dev/null -w "%{http_code}" "$@"
}

# Function to get Docker IP on macOS (Docker Desktop)
get_mac_docker_ip() {
  # Use localhost since Docker Desktop binds to localhost
  echo "localhost"
}

# Function to get the container's IP on Linux
get_linux_docker_ip() {
  container_id=$(docker ps -q --filter "status=running" --filter "name=message-service" | head -n 1)
  if [ -z "$container_id" ]; then
    print_warning "No running Docker containers found."
    echo "localhost"
  else
    container_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_id")
    echo "$container_ip"
  fi
}

# Detect the OS and fetch the correct Docker IP
function get_docker_ip() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    get_mac_docker_ip
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    get_linux_docker_ip
  else
    print_warning "Unsupported OS: $OSTYPE"
    echo "localhost"
  fi
}
# Function to generate a random message payload
function generate_message_payload() {
  local topic="Topic-$RANDOM"
  local message="Message content $RANDOM"
  echo "{\"topic\": \"$topic\", \"message\": \"$message\"}"
}

# Set the BASE_URL based on the detected Docker IP
docker_ip=$(get_docker_ip)
BASE_URL="http://${docker_ip}"
API_URL="${BASE_URL}:${PORT}/api/v1/messages"

# Create Random Messages
function create_random_messages() {
  for ((i = 1; i <= NUM_MESSAGES; i++)); do
    print_info "Creating message $i of $NUM_MESSAGES"
    payload=$(generate_message_payload)
    response_code=$(curl_request -X POST -H "Content-Type: application/json" -d "$payload" "${API_URL}")

    if [[ -z "$response_code" ]]; then
      print_error "Create message test failed: No response code received"
      exit 1
    elif [[ "$response_code" -eq 201 ]]; then
      print_info "Message $i created successfully."
    else
      print_error "Create message test failed with status code $response_code"
      exit 1
    fi
  done
}

# Update Random Messages
function update_random_messages() {
  for ((i = 1; i <= NUM_UPDATES; i++)); do
    print_info "Updating message $i of $NUM_UPDATES"
    update_payload=$(generate_message_payload)
    response_code=$(curl_request -X PUT -H "Content-Type: application/json" -d "$update_payload" "${API_URL}/$i")

    if [[ -z "$response_code" ]]; then
      print_error "Update message test failed: No response code received"
      exit 1
    elif [[ "$response_code" -eq 204 ]]; then
      print_info "Message $i updated successfully."
    else
      print_error "Update message test failed with status code $response_code"
      exit 1
    fi
  done
}

# Population function to create and update messages
function populate() {
  create_random_messages
  update_random_messages
}

# Execute the message population
populate