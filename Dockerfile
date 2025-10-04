# Dockerfile.jenkins
# Build Argument required for GID Synchronization
ARG DOCKER_GROUP_ID=999 

FROM jenkins/jenkins:lts
USER root

# 1. Install necessary dependencies (curl, ca-certificates, apt tools)
RUN apt-get update && apt-get install -y \
    lsb-release ca-certificates curl gnupg \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Docker CLI and Compose Plugin (using Debian repository setup)
# The Docker CLI is needed inside the container to communicate with the host socket.
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && apt-get install -y docker-ce-cli docker-compose-plugin

# 3. CRITICAL STEP: GID Synchronization and User Management
# Create the 'docker' group inside the container using the GID provided during build time.
# Then, add the Jenkins user (default UID 1000) to this newly created group.
RUN groupadd -g $DOCKER_GROUP_ID docker && usermod -aG docker jenkins

USER jenkins
# Jenkins is now ready to execute Docker commands on the host daemon via the socket mount.
