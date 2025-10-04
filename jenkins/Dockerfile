FROM jenkins/jenkins:lts

USER root

# Install Docker CLI and docker-compose inside Jenkins container
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    && curl -fsSL https://get.docker.com/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y docker-ce-cli docker-compose-plugin \
    && rm -rf /var/lib/apt/lists/*

# Install suggested Jenkins plugins (optional if you have plugins.txt)
# COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
# RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Switch back to Jenkins user
USER jenkins
