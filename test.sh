#!/usr/bin/env bash

IMAGE_NAME="diagnostic-cli"

echo "=== Building Docker Image ==="
docker build -t "$IMAGE_NAME" . >/dev/null 2>&1

echo -e "\n=== Running Test Cases ==="

# Test 1: System Command (Expected exit code 0)
echo -n "Test 1: 'system' command... "
docker run --rm "$IMAGE_NAME" system >/dev/null 2>&1
if [ $? -eq 0 ]; then echo "PASSED"; else echo "FAILED"; fi

# Test 2: Disk Command Valid (Expected exit code 0 or 1)
echo -n "Test 2: 'disk 99' command... "
docker run --rm "$IMAGE_NAME" disk 99 >/dev/null 2>&1
if [ $? -eq 0 ] || [ $? -eq 1 ]; then echo "PASSED"; else echo "FAILED"; fi

# Test 3: Disk Command Invalid Threshold (Expected exit code 2)
echo -n "Test 3: 'disk 150' invalid handling... "
docker run --rm "$IMAGE_NAME" disk 150 >/dev/null 2>&1
if [ $? -eq 2 ]; then echo "PASSED"; else echo "FAILED"; fi

# Test 4: Unknown Command (Expected exit code 2)
echo -n "Test 4: Unknown command handling... "
docker run --rm "$IMAGE_NAME" invalid-cmd >/dev/null 2>&1
if [ $? -eq 2 ]; then echo "PASSED"; else echo "FAILED"; fi

echo -e "\n=== Testing Complete ==="
