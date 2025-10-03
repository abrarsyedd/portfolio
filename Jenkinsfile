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
                    branch: 'master',
                    credentialsId: "${GITHUB_CREDENTIALS}"
                )
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
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USR', passwordVariable: 'DOCKERHUB_PSW')]) {
                        sh "echo ${DOCKERHUB_PSW} | docker login -u ${DOCKERHUB_USR} --password-stdin"
                        sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                        sh "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // FIX: Reverting to the reliable 'docker-compose' (hyphen) syntax.
                    // NOTE: We MUST remove the service names from the 'down' command when using hyphenated compose.
                    sh """
                    docker-compose down --remove-orphans
                    docker-compose pull app
                    docker-compose up -d
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
