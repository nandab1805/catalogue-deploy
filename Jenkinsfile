pipeline {
    agent {
        node {
            label 'Agent'
        }
    }
    options {
        timeout(time: 1, unit: 'HOURS') 
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
    parameters {
        string(name: 'version', defaultValue: '', description: 'What is artifact version?')
        string(name: 'environment', defaultValue: '', description: 'What is environment?')
        string(name: 'action', defaultValue: '', description: 'Action: apply or destroy')
    }
    stages {
        stage('Print version') {
            steps {
                sh """
                    echo "version: ${params.version}"                
                    echo "environment: ${params.environment}"
                """
            }
        }
        stage('Init') { 
            steps {
                sh """
                    cd terraform
                    terraform init --backend-config=${params.environment}/backend.tf -reconfigure
                """
            }
        }
        stage('Plan') { 
            steps {
                sh """
                    cd terraform
                    terraform plan -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}"                 
                """
            }
        }
        stage('Apply/Destroy') { 
            steps {
                script {
                    if (params.action == 'apply') {
                        sh """
                            cd terraform
                            terraform apply -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}" -auto-approve
                        """
                    } else if (params.action == 'destroy') {
                        input {
                            message "Are you sure you want to destroy the infrastructure?"
                            ok "Yes, continue with destroy."
                        }
                        sh """
                            cd terraform
                            terraform destroy -auto-approve
                        """
                    }
                }
            }
        }
    }
    post { 
        always { 
            sh "rm -f terraform/destroy"  // Remove the destroy file
            echo 'Pipeline finished.'
            deleteDir()
        }
        failure {
            echo 'Pipeline failed. Please review.'
        }
        success {
            echo 'Pipeline succeeded.'
        }
    }
}
