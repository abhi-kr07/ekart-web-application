pipeline {
    agent any

    tools {
        maven "maven3"
        jdk "jdk21"
    }

    environment {
        SCANNER_HOME = tool "sonar-scanner"
    }

    stages {
        stage("Git Checkout") {
            steps {
                git branch: 'main', url: 'https://github.com/abhi-kr07/ekart-web-application.git'
            }
        }

        stage('Compile') {
            steps {
                dir('ekart-app') {
                    sh 'mvn compile'
                }
                
            }
        }

        stage('Unit test') {
            steps {
                dir('ekart-app') {
                    sh 'mvn test -DskipTests=true'
                }
            }
        }

        stage("Sonarqube Analysis") {
            steps {
                dir("ekart-app") {
                    withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=EKART -Dsonar.projectName=EKART \
                    -Dsonar.java.binaries=. '''
                    }
                }
            }
        }

        // stage("OWASP Dependency check") {
        //     steps {
        //         dependencyCheck additionalArguments: ' --scan ./', odcInstallation: 'DC'
        //         dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //     }
        // }

        stage("Build") {
            steps {
                dir("ekart-app"){
                    sh "mvn package -DskipTests=true"
                }
            }
        }

        stage("Deploy to Nexus") {
            steps {
                dir("ekart-app"){
                    withMaven(globalMavenSettingsConfig: 'global-maven' , jdk: 'jdk21' , maven: 'maven3' , mavenSettingsConfig: '' , traceability: true) {
                    sh "mvn deploy -DskipTests=true"
                    }
                }
            }
        }

        stage('Docker build and tag') {
            steps {
                dir('ekart-app') {
                    script {
                        withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                            sh 'docker build -t abhishekk4/ekart:v1 -f docker/Dockerfile .'
                        }
                    }
                    
                }
            }
        }

        stage("Trivy scan") {
            steps {
                dir("ekart-app"){
                    sh "trivy image abhishekk4/ekart:v1 > trivy-report.txt"
                }
            }
        }

        stage('Docker push') {
            steps {
                dir('ekart-app') {
                    script {
                        withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                            sh 'docker push abhishekk4/ekart:v1'
                        }
                    }
                    
                }
            }
        }

        stage("Deploy to k8s-server") {
            steps {
                dir("ekart-app") {
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s-token', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://10.0.1.218:6443') {
                        sh 'kubectl apply -f manifests/ekart-deployment.yml'
                        sh 'kubectl apply -f manifests/ekart-svc.yml'
                    }
                }
            }
        }
        
    }
}