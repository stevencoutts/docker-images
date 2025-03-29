# Grafana Docker Project

This project contains Docker configuration for running Grafana in a containerized environment, including the Grafana Image Renderer for dashboard panel image exports.

## Prerequisites

- Docker
- Docker Compose

## Setup

1. Clone this repository
2. Build and start the containers:
   ```bash
   docker-compose up -d
   ```

## Accessing Grafana

Once the container is running, you can access Grafana at:
- URL: http://localhost:3000
- Default credentials:
  - Username: admin
  - Password: admin

## Features

- Grafana with persistent storage
- Grafana Image Renderer for dashboard panel image exports
- Automatic container restart
- Secure default configuration

## Configuration

The default configuration can be modified by:
1. Editing the environment variables in `docker-compose.yml`
2. Uncommenting and modifying the `grafana.ini` configuration in the Dockerfile
3. Creating a custom `grafana.ini` file and uncommenting the COPY line in the Dockerfile

## Image Renderer

The Grafana Image Renderer service is included and configured to handle dashboard panel image exports. It runs on port 8085 and is automatically connected to the main Grafana instance.

## Persistence

Grafana data is persisted using a Docker volume named `grafana-storage`. This ensures your dashboards and configurations survive container restarts.

## Stopping the Service

To stop Grafana:
```bash
docker-compose down
```

To stop and remove all data:
```bash
docker-compose down -v
``` 