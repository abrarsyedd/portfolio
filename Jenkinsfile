pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        GITHUB_CREDENTIALS = credentials('github-creds')
        DOCKER_IMAGE = "syed048/portfolio-app"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git(
                        branch: 'master',
                        url: 'https://github.com/abrarsyedd/portfolio.git',
                        credentialsId: "${GITHUB_CREDENTIALS}"
                    )
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
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
                    docker-compose -f docker-compose.yml down --remove-orphans
                    docker-compose -f docker-compose.yml pull app
                    docker-compose -f docker-compose.yml up -d
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

