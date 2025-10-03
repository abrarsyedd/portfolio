pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "syed048/portfolio-app:${BUILD_NUMBER}"
    DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
    GITHUB_CREDENTIALS = 'github-creds'
  }
  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/abrarsyedd/portfolio.git', credentialsId: "${GITHUB_CREDENTIALS}"
      }
    }
    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${DOCKER_IMAGE} ."
      }
    }
    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: "${DOCKERHUB_CREDENTIALS}", usernameVariable: 'USER', passwordVariable: 'PASS')]) {
          sh "echo \$PASS | docker login -u \$USER --password-stdin"
          sh "docker push ${DOCKER_IMAGE}"
        }
      }
    }
    stage('Deploy') {
      steps {
        sh "/usr/local/bin/docker-compose -f docker-compose.yml down || true"
        sh "/usr/local/bin/docker-compose -f docker-compose.yml up -d --build"
      }
    }
  }
  post {
    always {
      echo "Pipeline finished."
    }
  }
}
