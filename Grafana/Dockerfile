FROM grafana/grafana:latest

# Install dependencies for image renderer
RUN apt-get update && apt-get install -y \
    chromium \
    fonts-ipafont-gothic \
    fonts-wqy-zenhei \
    fonts-thai-tlwg \
    fonts-kacst \
    fonts-freefont-ttf \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for image renderer
ENV CHROME_BIN=/usr/bin/chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium

# Expose the default Grafana port
EXPOSE 3000

# Set environment variables
ENV GF_SECURITY_ADMIN_USER=admin
ENV GF_SECURITY_ADMIN_PASSWORD=admin
ENV GF_USERS_ALLOW_SIGN_UP=false

# Enable image renderer
ENV GF_RENDERING_SERVER_URL=http://grafana-image-renderer:8085/render
ENV GF_RENDERING_CALLBACK_URL=http://grafana:3000/

# Copy custom configuration if needed
# COPY grafana.ini /etc/grafana/grafana.ini

# Set the entrypoint
ENTRYPOINT ["/run.sh"] 