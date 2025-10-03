pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        GITHUB_CREDENTIALS = credentials('github-creds')
        DOCKER_IMAGE = "syed048/portfolio-app"
        WORKSPACE_PATH = "/workspace"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout inside Jenkins workspace (this will also populate /var/jenkins_home/workspace/..., but we rely on host-mounted /workspace in the container)
                git(
                    url: 'https://github.com/abrarsyedd/portfolio.git',
                    branch: 'master',
                    credentialsId: 'github-creds'
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ${WORKSPACE_PATH}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh """
                    set -e

                    # run compose from workspace (host-mounted)
                    cd ${WORKSPACE_PATH}

                    # bring down any leftover containers
                    docker-compose down --remove-orphans || true

                    # build the app image so it has the client tools installed
                    docker-compose build --no-cache app

                    # start only the DB first
                    docker-compose up -d db

                    # wait until mysql container health is healthy (uses container name 'portfolio-db')
                    echo "Waiting for DB health..."
                    until [ "\$(docker inspect -f '{{.State.Health.Status}}' portfolio-db 2>/dev/null)" = "healthy" ]; do
                      echo "DB not healthy yet..."
                      sleep 2
                    done

                    # Run db-init service (one-shot)
                    docker-compose up -d db-init

                    # wait for db-init to finish (container stops when done)
                    while [ "\$(docker inspect -f '{{.State.Running}}' portfolio-db-init 2>/dev/null)" = "true" ]; do
                      echo "Waiting for db-init to finish..."
                      sleep 2
                    done

                    # optional: remove the db-init container (cleanup)
                    docker-compose rm -f db-init || true

                    # finally start app + adminer
                    docker-compose up -d --no-build app adminer
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finished."
        }
    }
}
