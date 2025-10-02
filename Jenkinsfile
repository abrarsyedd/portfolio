pipeline {
    agent any

    environment {
        DOCKERHUB = credentials('dockerhub-creds')
        GITHUB = credentials('github-creds')
        IMAGE = "syed048/portfolio-app"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/abrarsyedd/portfolio.git',
                    branch: 'master',
                    credentialsId: "${GITHUB}"
            }
        }

        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE}:${BUILD_NUMBER} -t ${IMAGE}:latest ."
            }
        }

        stage('Push Image') {
            steps {
                sh "echo ${DOCKERHUB_PSW} | docker login -u ${DOCKERHUB_USR} --password-stdin"
                sh "docker push ${IMAGE}:${BUILD_NUMBER}"
                sh "docker push ${IMAGE}:latest"
            }
        }

        stage('Deploy') {
            steps {
                sh """
                  docker-compose down --remove-orphans
                  docker-compose pull app
                  docker-compose up -d
                """
            }
        }
    }
}

