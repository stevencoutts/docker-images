# ELK Stack Docker Setup

This repository contains Docker configuration for running the ELK (Elasticsearch, Logstash, Kibana) stack, specifically configured for OPNsense log collection and visualization.

## Components

- **Elasticsearch** (v7.10.2): Search and analytics engine
- **Logstash** (v7.10.2): Data processing pipeline
- **Kibana** (v7.10.2): Data visualization dashboard

## Prerequisites

- Docker and Docker Compose
- At least 4GB of RAM (8GB recommended)
- At least 20GB of free disk space.

## Quick Start

1. Create the required network:
```bash
docker network create elk
```

2. Start the stack:
```bash
docker-compose up -d
```

3. Access Kibana:
   - Open http://localhost:5601 in your browser
   - Default credentials: elastic / changeme (if not configured)

## Configuration

### Elasticsearch
- Single-node setup
- Memory settings: 512MB heap
- Data persistence through Docker volume
- Port: 9200

### Logstash
- Syslog input on UDP/TCP port 514
- Beats input on port 5044
- Memory settings: 256MB heap
- Configuration file: `logstash/config/logstash.conf`

### Kibana
- Web interface on port 5601
- Security enabled with encryption key
- Connected to Elasticsearch

## OPNsense Integration

1. Configure OPNsense to send logs:
   - Go to System → Log Files → Settings
   - Enable "Send log messages to remote syslog server"
   - Set remote syslog server to your server's IP
   - Select facilities to forward (recommended: all)

2. Create Kibana Index Pattern:
   - Go to Management → Stack Management → Index Patterns
   - Create index pattern for "syslog-*"
   - Set time field to "@timestamp"

## Monitoring

- Elasticsearch health: http://localhost:9200/_cluster/health
- Kibana status: http://localhost:5601/api/status

## Security

- X-Pack security is enabled
- Encryption key is configured
- Default ports are exposed

## Maintenance

### Backup
Elasticsearch data is stored in a Docker volume named `esdata`. To backup:
```bash
docker run --rm -v esdata:/source -v $(pwd)/backup:/backup alpine tar czf /backup/elasticsearch_backup.tar.gz -C /source .
```

### Restore
To restore from backup:
```bash
docker run --rm -v esdata:/target -v $(pwd)/backup:/backup alpine sh -c "cd /target && tar xzf /backup/elasticsearch_backup.tar.gz"
```

## Troubleshooting

1. Check container logs:
```bash
docker logs elasticsearch
docker logs logstash
docker logs kibana
```

2. Common issues:
   - Memory issues: Adjust ES_JAVA_OPTS and LS_JAVA_OPTS in docker-compose.yml
   - Network connectivity: Ensure the 'elk' network exists
   - Kibana connection: Verify Elasticsearch is running and accessible

## Development

### Building from source
```bash
docker-compose build
```

### Testing
```bash
docker-compose -f docker-compose.test.yml up
```

## License

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org> 