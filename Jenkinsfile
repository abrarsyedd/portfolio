// Jenkinsfile (Declarative Pipeline)

pipeline {
    agent any

    environment {
        // Pipeline variables
        DOCKERHUB_REPO = 'syed048/portfolio-app'
        APP_COMPOSE_FILE = 'app-compose.yml'
        # Retrieve the DB password from Jenkins Secret Text credential (ID: mysql-root-secret)
        DB_ROOT_PASSWORD = credentials('mysql-root-secret') 
    }

    stages {
        stage('Source Checkout') {
            steps {
                echo "Cloning GitHub repository..."
                // Use the configured GitHub credentials (ID: github-creds)
                checkout(scm:], 
                    userRemoteConfigs: [[
                        credentialsId: 'github-creds',
                        url: 'https://github.com/abrarsyedd/portfolio.git'
                    ]])
            }
        }

        stage('Build & Tag Docker Image') {
            steps {
                script {
                    def appImageTag = "${DOCKERHUB_REPO}:${env.BUILD_ID}"
                    echo "Building Docker image: ${appImageTag}"
                    
                    // Build the application image using the Docker CLI (via DooD socket)
                    sh "docker build -t ${appImageTag} -f Dockerfile."
                    
                    // Set the tag for deployment
                    env.BUILD_TAG = appImageTag 
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Log in using stored Docker Hub credentials (ID: dockerhub-creds)
                    withCredentials() {
                        // Login, then push the specific build tag and the 'latest' tag
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                        sh "docker push ${env.BUILD_TAG}"
                        sh "docker tag ${env.BUILD_TAG} ${DOCKERHUB_REPO}:latest"
                        sh "docker push ${DOCKERHUB_REPO}:latest"
                        sh "docker logout"
                    }
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo "Deploying application services via docker compose..."
                
                // The deployment is managed by the installed Docker Compose CLI via DooD
                script {
                    // Export environment variables required by app-compose.yml for image tag and database access
                    sh """
                    export BUILD_TAG=${env.BUILD_TAG}
                    export DB_ROOT_PASSWORD=${env.DB_ROOT_PASSWORD}
                    
                    # Good Practice: Stop, remove, and pull to ensure a clean start with the new image [6]
                    docker compose -f ${APP_COMPOSE_FILE} down --remove-orphans
                    
                    # Start the services (Node.js and MySQL)
                    docker compose -f ${APP_COMPOSE_FILE} up -d 
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
