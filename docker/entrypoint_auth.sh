#!/bin/sh
set -e  # Exit immediately if a command fails

# Get the current working directory (WORKDIR from Dockerfile)
WORKDIR=$(pwd)

# Ensure PORT is set, or use default 8001
PORT=${PORT:-8000}

# Replace the port in the supervisord config
echo "Updating Gunicorn port in supervisord_api.conf to: $PORT"
sed -i "s/0.0.0.0:8000/0.0.0.0:$PORT/g" /etc/supervisord.conf

# Run collectstatic
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Start Supervisor
echo "🚀 Starting Supervisor..."
exec supervisord -c /etc/supervisord.conf
