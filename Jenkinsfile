pipeline {
    // The 'any' agent means the pipeline runs on the controller node (the Jenkins container itself)
    agent any

    environment {
        // Credentials must be set up in Jenkins UI with these IDs
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
                    // Uses the host Docker daemon via the mounted socket
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Login using the credentials defined in the Jenkins environment
                    sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Execute docker-compose on the EC2 host using the mounted binary and files in the workspace.
                    // Using the full path /usr/local/bin/docker-compose ensures the command is found.
                    sh """
                    /usr/local/bin/docker-compose down --remove-orphans
                    /usr/local/bin/docker-compose pull app
                    /usr/local/bin/docker-compose up -d
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
