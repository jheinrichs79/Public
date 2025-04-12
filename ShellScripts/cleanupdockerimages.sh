#!/bin/bash
# Get all container IDs (running and stopped)
containers=$(docker ps -aq)

# Check if there are any containers
if [ -n "$containers" ]; then
    echo "Removing all Docker containers..."
    # Force remove all containers
    docker rm -f $containers
    echo "All containers have been removed."
else
    echo "No containers found."
fi

# Get all image IDs
images=$(docker images -q)

# Check if there are any images
if [ -n "$images" ]; then
    echo "Removing all Docker images..."
    # Force remove all images
    docker rmi -f $images
    echo "All images have been removed."
else
    echo "No images found."
fi
