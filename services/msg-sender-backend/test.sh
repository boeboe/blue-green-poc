#!/usr/bin/env bash

# Configuration
BASE_URL=${BASE_URL:-"http://localhost"}
PORT=${PORT:-8080}
API_URL="${BASE_URL}:${PORT}/api/v1/messages"

# Colors
end="\033[0m"
redb="\033[1;31m"
greenb="\033[1;32m"

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

# Create Message Test
function test_create_message() {
  print_info "Running Create Message Test"

  PAYLOAD='{
    "topic": "Test Topic",
    "message": "Test Message"
  }'

  response_code=$(curl_request -X POST -H "Content-Type: application/json" \
    -d "$PAYLOAD" "${API_URL}")

  if [ "$response_code" -eq 201 ]; then
      print_info "Create message test passed"
  else
      echo "Create message test failed with status code $response_code"
      exit 1
  fi
}

# Get Messages Test
function test_get_messages() {
  print_info "Running Get Messages Test"

  response_code=$(curl_request -X GET "${API_URL}")

  if [ "$response_code" -eq 200 ]; then
      print_info "Get messages test passed"
  else
      print_error "Get messages test failed with status code $response_code"
      exit 1
  fi
}

# Update Message Test
function test_update_message() {
  print_info "Running Update Message Test"

  UPDATE_PAYLOAD='{
    "topic": "Updated Topic",
    "message": "Updated Message"
  }'

  response_code=$(curl_request -X PUT -H "Content-Type: application/json" \
    -d "$UPDATE_PAYLOAD" "${API_URL}/1")

  if [ "$response_code" -eq 204 ]; then
      print_info "Update message test passed"
  else
      print_error "Update message test failed with status code $response_code"
      exit 1
  fi
}

# Delete Message Test
function test_delete_message() {
  print_info "Running Delete Message Test"

  response_code=$(curl_request -X DELETE "${API_URL}/1")

  if [ "$response_code" -eq 204 ]; then
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