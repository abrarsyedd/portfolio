// Jenkinsfile (Declarative)
pipeline {
  agent any

  environment {
    DOCKERHUB_CREDS = credentials('dockerhub-creds') // username/password secret text
    GIT_CREDS = credentials('github-creds')
    DOCKER_IMAGE = "syed048/portfolio-app"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout([$class: 'GitSCM',
          branches: [[name: '*/master']],
          userRemoteConfigs: [[url: 'https://github.com/abrarsyedd/portfolio.git', credentialsId: "${GIT_CREDS}"]]
        ])
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
        }
      }
    }

    stage('Docker Login & Push') {
      steps {
        script {
          // DOCKERHUB_CREDS contains username/password
          sh """
            echo "${DOCKERHUB_CREDS_PSW}" | docker login -u "${DOCKERHUB_CREDS_USR}" --password-stdin
            docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
            docker push ${DOCKER_IMAGE}:latest
            docker logout
          """
        }
      }
    }

    stage('Deploy (docker-compose)') {
      steps {
        script {
          // Using the docker-compose.app.yml that is in repo root
          // This will pull the new image and restart the app service only.
          sh """
            docker-compose -f docker-compose.app.yml pull app || true
            docker-compose -f docker-compose.app.yml up -d --remove-orphans
          """
        }
      }
    }
  }

  post {
    success {
      echo "Build ${BUILD_NUMBER} finished successfully."
    }
    failure {
      echo "Build ${BUILD_NUMBER} failed."
    }
    always {
      echo "Pipeline finished."
    }
  }
}
