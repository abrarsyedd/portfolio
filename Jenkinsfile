pipeline {
    // We use a clean node:18-alpine image as the pipeline agent
    // This agent image has npm/node for any potential test stages (not shown)
    // and relies on the mounted host docker binary for build/push/deploy commands.
    agent any

    environment {
        // Assume these credentials are set up in Jenkins
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        GITHUB_CREDENTIALS = credentials('github-creds')
        DOCKER_IMAGE = "syed048/portfolio-app"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the repository containing your Dockerfile, docker-compose.yml, .env, etc.
                git(
                    url: 'https://github.com/abrarsyedd/portfolio.git',
                    branch: 'master',
                    credentialsId: "${GITHUB_CREDENTIALS}"
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Uses the Docker daemon from the host EC2 machine
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                // ${DOCKERHUB_CREDENTIALS_USR} and ${DOCKERHUB_CREDENTIALS_PSW} are automatically
                // available when using the 'Secret Text' or 'Username with password' credential type.
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
                    // Check if the application stack is running, stop it, and remove orphaned containers.
                    // The app service will pull the 'latest' image we just pushed.
                    sh """
                    /usr/local/bin/docker-compose down --remove-orphans
                    /usr/local/bin/docker-compose pull app
                    /usr/local/bin/docker-compose up -d
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
