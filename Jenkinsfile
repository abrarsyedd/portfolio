// Jenkinsfile
pipeline {
  agent any
  environment {
    DOCKER_IMAGE = "syed048/portfolio-app"
    COMPOSE_FILE_PATH = "${WORKSPACE}/docker-compose.yml" // adjust if docker-compose.yml lives elsewhere on host
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
        }
      }
    }

    stage('Login & Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PSW')]) {
          sh """
            echo "$DOCKERHUB_PSW" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
            docker push ${DOCKER_IMAGE}:latest
          """
        }
      }
    }

    stage('Deploy to Host with docker-compose') {
      steps {
        // This step assumes Jenkins has access to docker and docker-compose on the host (via mounted socket & docker-compose binary).
        // It updates the app service by pulling the newly pushed image and starting the container.
        script {
          sh """
            # make sure we use the compose file in your repository or a pre-agreed location on the host
            if [ -f "${COMPOSE_FILE_PATH}" ]; then
              docker-compose -f "${COMPOSE_FILE_PATH}" pull app || true
              docker-compose -f "${COMPOSE_FILE_PATH}" up -d --no-deps --build app
            else
              echo "Compose file not found at ${COMPOSE_FILE_PATH}"
              exit 1
            fi
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
