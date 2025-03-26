#!/bin/bash

# Set error handling
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    error "Please run as root"
    exit 1
fi

# Get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change to the script directory
cd "$SCRIPT_DIR"

# Backup current configuration
log "Creating backup of current configuration..."
BACKUP_DIR="backup_$(date +'%Y%m%d_%H%M%S')"
mkdir -p "$BACKUP_DIR"
cp docker-compose.yml "$BACKUP_DIR/"
cp -r logstash/config "$BACKUP_DIR/"

# Pull latest images
log "Pulling latest images..."
docker-compose pull

# Stop containers
log "Stopping containers..."
docker-compose down

# Start containers with new images
log "Starting containers with new images..."
docker-compose up -d

# Wait for services to be healthy
log "Waiting for services to be healthy..."
sleep 30

# Check if services are running
if docker-compose ps | grep -q "Up"; then
    log "All services are up and running!"
    
    # Check Elasticsearch
    if curl -s http://localhost:9200/_cluster/health | grep -q "green"; then
        log "Elasticsearch is healthy"
    else
        warn "Elasticsearch might not be healthy, please check manually"
    fi
    
    # Check Kibana
    if curl -s http://localhost:5601/api/status | grep -q "available"; then
        log "Kibana is healthy"
    else
        warn "Kibana might not be healthy, please check manually"
    fi
    
    # Check Logstash
    if docker-compose logs logstash | grep -q "Pipeline started successfully"; then
        log "Logstash is healthy"
    else
        warn "Logstash might not be healthy, please check manually"
    fi
else
    error "Some services failed to start. Please check the logs with 'docker-compose logs'"
    exit 1
fi

log "Update completed successfully!"
log "Backup is available in: $BACKUP_DIR" 