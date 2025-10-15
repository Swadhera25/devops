pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "shivay2525/devops"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Swadhera25/devops.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t shivay2525/devops.'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat '''
                        docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                        docker push shivay2525/devops
                    '''
                }
            }
        }
    }

    post {
        always {
            // Good practice: always log out to clean up credentials from the agent
            echo 'Logging out from Docker Hub...'
            bat 'docker logout'
        }
        success {
            echo "✅ Docker image built and pushed successfully to Docker Hub!"
        }
        failure {
            echo "❌ Build or push failed!"
        }
    }
}
