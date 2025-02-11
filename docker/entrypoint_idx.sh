#!/bin/sh
set -e  # Exit immediately if a command fails

# Get the current working directory (WORKDIR from Dockerfile)
WORKDIR=$(pwd)

echo "🛠️ Using WORKDIR: $WORKDIR"

# Start Supervisor
echo "🚀 Starting Supervisor..."
exec supervisord -c /etc/supervisord.conf
