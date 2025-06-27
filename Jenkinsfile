pipeline {
    agent {
        kubernetes {
            label 'docker-builder'
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins: slave
    app: docker-builder
spec:
  serviceAccountName: jenkins-admin
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
    resources:
      requests:
        memory: "512Mi"
        cpu: "500m"
      limits:
        memory: "1Gi"
        cpu: "1000m"
  - name: docker
    image: docker:24.0.6-cli
    command: ['sleep']
    args: ['99999']
    volumeMounts:
    - name: docker-sock
      mountPath: /var/run/docker.sock
    resources:
      requests:
        memory: "256Mi"
        cpu: "200m"
      limits:
        memory: "512Mi"
        cpu: "500m"
  - name: buildtools
    image: alpine:3.18
    command: ['sleep']
    args: ['99999']
    resources:
      requests:
        memory: "128Mi"
        cpu: "100m"
      limits:
        memory: "256Mi"
        cpu: "200m"
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock
      type: Socket
            """
        }
    }
    
    environment {
        IMAGE_NAME = 'myapp'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                container('jnlp') {
                    checkout scm
                }
            }
        }
        
        stage('Build and Push Docker Image') {
            steps {
                container('docker') {
                  script {
                    sh """
                        withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',usernameVariable: 'DOCKER_USERNAME',passwordVariable:'DOCKER_PASSWORD')]) 
                        REPO = "akshaypgore"
                        docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                        docker push ${REPO}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                    """
                  }
                }
            }
        }
    }
    
}