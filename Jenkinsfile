pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "syed048/portfolio-app"
        APP_COMPOSE = "docker-compose.app.yml"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/abrarsyedd/portfolio.git',
                        credentialsId: 'github-creds'
                    ]]
                ])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Docker Login & Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh 'echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Deploy (app stack only)') {
            steps {
                script {
                    // Ensure we only operate on the app compose file - this avoids touching Jenkins
                    sh """
                      docker-compose -f ${APP_COMPOSE} pull app || true
                      docker-compose -f ${APP_COMPOSE} up -d --remove-orphans
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
