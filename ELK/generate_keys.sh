#!/bin/bash

# Generate a secure 32-character key
generate_key() {
    openssl rand -base64 24 | tr -d '\n' | tr -d '/'
}

# Create the config directory if it doesn't exist
mkdir -p kibana/config

# Generate keys
ENCRYPTION_KEY=$(generate_key)

# Create kibana.yml with the generated key
cat > kibana/config/kibana.yml << EOF
# Server
server.host: "0.0.0.0"
server.port: 5601

# Elasticsearch
elasticsearch.hosts: ["http://elasticsearch:9200"]

# Security
xpack.security.enabled: true
xpack.security.encryptionKey: "${ENCRYPTION_KEY}"
xpack.encryptedSavedObjects.encryptionKey: "${ENCRYPTION_KEY}"

# Reporting
xpack.reporting.encryptionKey: "${ENCRYPTION_KEY}"
xpack.reporting.kibanaServer.hostname: "0.0.0.0"
xpack.reporting.capture.browser.chromium.disableSandbox: true

# Monitoring
xpack.monitoring.enabled: true
xpack.monitoring.cluster_alerts.email_notifications.email_address: "your-email@example.com"

# Logging
logging.root.level: info
logging.root.appenderRefs: ["console"]
logging.appenders.console.type: console
logging.appenders.console.layout.type: json
EOF

echo "Generated Kibana configuration with secure encryption keys"
echo "Please update the email address in kibana/config/kibana.yml" 