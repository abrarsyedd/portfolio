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
                git branch: 'master', url: 'https://github.com/abrarsyedd/portfolio.git'
            }
        }

        stage('Build with Docker Compose') {
            steps {
                sh 'docker-compose down -v'
                sh 'docker-compose up -d --build'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                echo "$DOCKERHUB_CREDENTIALS_PSW" | docker login -u "$DOCKERHUB_CREDENTIALS_USR" --password-stdin
                docker build -t $DOCKER_IMAGE:latest .
                docker push $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker-compose down -v'
                sh 'docker-compose up -d --build'
            }
        }
    }
}

