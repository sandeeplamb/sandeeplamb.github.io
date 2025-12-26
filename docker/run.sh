#!/bin/bash

# Script to run Jekyll site locally using Docker Compose

set -e

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the docker directory
cd "$SCRIPT_DIR"

echo "🚀 Starting Jekyll site..."
echo ""
echo "📝 The site will be available at: http://localhost:4000"
echo "🛑 Press Ctrl+C to stop the server"
echo ""

# Run docker-compose
docker-compose up

