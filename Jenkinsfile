pipeline {
    agent any
    environment {
        UI_HOST_PORT = '8200'
    }
    stages {
        stage('Bake Docker image with Vault provisioning') {
            steps {
                sh 'packer init ./packer/docker_ubuntu.pkr.hcl'
                sh 'packer build ./packer/docker_ubuntu.pkr.hcl'
            }
        }
        stage('Remove old container') {
            when {
                not {
                    expression {
                        return sh(returnStdout: true, script: 'docker ps -a -f name=vault -q').trim() == ""
                    }
                }
            }
            steps {
                sh 'docker stop vault'
                sh 'docker rm vault'
            }
        }
        stage('Run Docker container') {
            steps {
                sh 'docker run --name vault -p ${UI_HOST_PORT}:8200 -d femelloffm/vault:ubuntu20.04'
            }
        }
    }
}