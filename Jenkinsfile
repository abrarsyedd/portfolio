pipeline {
    agent any
    environment {
        DOCKER_IMAGE = "syed048/portfolio-app"
    }
    stages {
        stage('Checkout from GitHub') {
            steps {
                git(
                    url: 'https://github.com/abrarsyedd/portfolio.git',
                    credentialsId: 'github-creds',
                    branch: 'master'
                )
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                }
            }
        }
        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }
        stage('Deploy with Docker Compose') {
            steps {
                script {
                    sh "docker-compose down || true"
                    sh "docker-compose up -d --build"
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
