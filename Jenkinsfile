pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "shivay2525/devops"   // Docker Hub repo name
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/Swadhera25/devops.git'
            }
        }

        stage('Build Java Application') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image on Windows agent
                    bat 'docker build -t %DOCKER_IMAGE%:latest .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Login to Docker Hub
                        bat 'echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin'
                        
                        // Retry push in case of network issues
                        retry(3) {
                            bat 'docker push %DOCKER_IMAGE%:latest'
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
            echo '✅ Docker image built and pushed successfully!'
        }
        failure {
            echo "❌ Build or push failed!"
        }
    }
}
