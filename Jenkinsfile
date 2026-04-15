@Library("Shared") _
pipeline {
    agent any

    environment {
        SONAR_HOME = tool "Sonar"
    }

    stages {

        stage("Clone Code From Github") {
            steps {
                git url: "https://github.com/imJENIL/Expenses-Tracker-WebApp", branch: "main"
            }
        }


        stage("SonarQube Quality Analysis") {
            steps {
                withSonarQubeEnv("Sonar") {
                    sh """
                    $SONAR_HOME/bin/sonar-scanner \
                      -Dsonar.projectKey=expensestracker \
                      -Dsonar.projectName=expensestracker \
                      -Dsonar.sources=. \
                      -Dsonar.java.binaries=target/classes \
                      -Dsonar.exclusions=mysql-data/** \
                      -Dsonar.coverage.exclusions=mysql-data/** \
                      -Dsonar.cpd.exclusions=mysql-data/**
                    """
                }
            }
        }
        
        stage("OWASP Dependency Check"){
            steps{
                dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'dc'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        
        stage("Sonar Quality Gate Scan"){
            steps{
                timeout(time: 2, unit: "MINUTES"){
                    waitForQualityGate abortPipeline: false
                }
            }
        }
        
        stage("Trivy File Systemc Scan"){
            steps{
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        
        stage("Build Stage"){
            steps{
                sh "docker build -t expenses-tracking:latest ."
            }
        }
        
        stage("Push Code to Docker hub"){
            steps{
                script{
                    docker_push("expenses-tracking", "latest", "imjenil")
                }
            }
        }
        
        stage("Deploy Stage"){
            steps{
                sh '''
                docker-compose down || true
                docker-compose up -d --build
                '''
                
            }
        }
        
    }
}
