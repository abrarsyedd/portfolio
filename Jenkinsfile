pipeline {
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        GITHUB_CREDENTIALS = credentials('github-creds')
        DOCKER_IMAGE = "syed048/portfolio-app"
        WORKSPACE_PATH = "${env.WORKSPACE}"   // Jenkins sets this
    }

    stages {
        stage('Checkout') {
            steps {
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
                    // Ensure init.sql is in workspace (needed for MySQL init)
                    sh "ls -l ${WORKSPACE_PATH}/init.sql"

                    sh """
                    docker-compose -f ${WORKSPACE_PATH}/docker-compose.yml down --remove-orphans
                    docker-compose -f ${WORKSPACE_PATH}/docker-compose.yml up -d --build
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
