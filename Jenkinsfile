pipeline {
    agent any

    environment {
        // Your Docker Hub username/repository
        DOCKER_IMAGE = "shivay2525/devops"
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout from main branch
                git branch: 'main', url: 'https://github.com/Swadhera25/devops.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build and tag with both 'latest' and the unique build number
                    // Note the double quotes and ${...} for cross-platform compatibility
                    bat "docker build -t ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER} -t ${env.DOCKER_IMAGE}:latest ."
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Login to Docker Hub
                        bat "echo ${DOCKER_PASS} | docker login -u ${DOCKER_USER} --password-stdin"
                        
                        // Push the image with the build number tag
                        retry(3) {
                            bat "docker push ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER}"
                        }

                        // Push the 'latest' tag
                        retry(3) {
                            bat "docker push ${env.DOCKER_IMAGE}:latest"
                        }
                    }
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
            echo "✅ Docker image ${env.DOCKER_IMAGE}:${env.BUILD_NUMBER} pushed successfully!"
        }
        failure {
            echo '❌ Build failed!'
        }
    }
}
