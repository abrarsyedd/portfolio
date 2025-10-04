# jenkins/Dockerfile
FROM jenkins/jenkins:lts

# Switch to root to install extras
USER root

# Install docker CLI and docker-compose
RUN apt-get update -y && \
    apt-get install -y ca-certificates curl gnupg lsb-release apt-transport-https && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
       > /etc/apt/sources.list.d/docker.list && \
    apt-get update -y && apt-get install -y docker-ce-cli && \
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
       -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure the jenkins user can use docker by accessing mounted socket at runtime
USER jenkins
