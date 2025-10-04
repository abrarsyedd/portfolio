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
                git(
                    url: 'https://github.com/abrarsyedd/portfolio.git',
                    branch: 'master'
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds',
                                usernameVariable: 'DOCKERHUB_USER',
                                passwordVariable: 'DOCKERHUB_PSW')]) {
                    sh """
                      echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USER --password-stdin
                      docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                      docker push ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }

        stage('Deploy to Host') {
            steps {
                // Run compose for app stack only, not Jenkins
                sh """
                  docker-compose -f docker-compose.yml down --remove-orphans
                  docker-compose -f docker-compose.yml pull app
                  docker-compose -f docker-compose.yml up -d
                """
            }
        }
    }
}

