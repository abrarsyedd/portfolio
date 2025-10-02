pipeline {
    agent any

    environment {
        IMAGE = "syed048/portfolio-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/abrarsyedd/portfolio.git',
                    branch: 'master',
                    credentialsId: 'github-creds'
            }
        }

        stage('Docker Info') {
            steps {
                sh 'docker --version'
                sh 'docker-compose --version'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE}:${BUILD_NUMBER} -t ${IMAGE}:latest ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                                 usernameVariable: 'DOCKERHUB_USER',
                                                 passwordVariable: 'DOCKERHUB_PASS')]) {
                    sh 'echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin'
                    sh "docker push ${IMAGE}:${BUILD_NUMBER}"
                    sh "docker push ${IMAGE}:latest"
                }
            }
        }

        stage('Deploy with Compose') {
            steps {
                sh """
                  docker-compose down --remove-orphans || true
                  docker-compose pull app
                  docker-compose up -d --remove-orphans
                """
            }
        }
    }

    post {
        always {
            echo "Pipeline finished"
        }
    }
}
