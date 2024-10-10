#!/usr/bin/env bash

# Configuration
PORT=${PORT:-8080}
BASE_URL="http://localhost"
API_URL="${BASE_URL}:${PORT}/api/v1/messages"

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

# Print warning messages
function print_warning {
  echo -e "${yellowb}${1}${end}"
}

# Print error messages
function print_error {
  echo -e "${redb}${1}${end}"
}

# Print command messages
function print_command {
  echo -e "${lightblueb}${1}${end}"
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
  container_id=$(docker ps -q --filter "status=running" | head -n 1)
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

# Set the BASE_URL based on the detected Docker IP
docker_ip=$(get_docker_ip)
BASE_URL="http://${docker_ip}"
API_URL="${BASE_URL}:${PORT}/api/v1/messages"


# Create Message Test
function test_create_message() {
  print_info "Running Create Message Test"

  PAYLOAD_FILE="payloads/create_message.json"
  print_command "curl -X POST -H \"Content-Type: application/json\" -d @\"$PAYLOAD_FILE\" \"${API_URL}\""
  response_code=$(curl_request -X POST -H "Content-Type: application/json" -d @"$PAYLOAD_FILE" "${API_URL}")

  if [[ -z "$response_code" ]]; then
      print_error "Create message test failed: No response code received"
      exit 1
  elif [[ "$response_code" -eq 201 ]]; then
      print_info "Create message test passed"
  else
      print_error "Create message test failed with status code $response_code"
      exit 1
  fi
}

# Get Messages Test
function test_get_messages() {
  print_info "Running Get Messages Test"

  print_command "curl -X GET \"${API_URL}\""
  response_code=$(curl_request -X GET "${API_URL}")

  if [[ -z "$response_code" ]]; then
      print_error "Get messages test failed: No response code received"
      exit 1
  elif [[ "$response_code" -eq 200 ]]; then
      print_info "Get messages test passed"
  else
      print_error "Get messages test failed with status code $response_code"
      exit 1
  fi
}

# Update Message Test
function test_update_message() {
  print_info "Running Update Message Test"

  UPDATE_PAYLOAD_FILE="payloads/update_message.json"
  print_command "curl -X PUT -H \"Content-Type: application/json\" -d @\"$UPDATE_PAYLOAD_FILE\" \"${API_URL}/1\""
  response_code=$(curl_request -X PUT -H "Content-Type: application/json" -d @"$UPDATE_PAYLOAD_FILE" "${API_URL}/1")

  if [[ -z "$response_code" ]]; then
      print_error "Update message test failed: No response code received"
      exit 1
  elif [[ "$response_code" -eq 204 ]]; then
      print_info "Update message test passed"
  else
      print_error "Update message test failed with status code $response_code"
      exit 1
  fi
}

# Delete Message Test
function test_delete_message() {
  print_info "Running Delete Message Test"

  print_command "curl -X DELETE \"${API_URL}/1\""
  response_code=$(curl_request -X DELETE "${API_URL}/1")

  if [[ -z "$response_code" ]]; then
      print_error "Delete message test failed: No response code received"
      exit 1
  elif [[ "$response_code" -eq 204 ]]; then
      print_info "Delete message test passed"
  else
      print_error "Delete message test failed with status code $response_code"
      exit 1
  fi
}

# Main function to run all tests
function run_all_tests() {
  test_create_message
  test_get_messages
  test_update_message
  test_delete_message
}

# Execute the tests
run_all_tests