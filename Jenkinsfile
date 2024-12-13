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
        string(name: 'version', defaultValue: '', description: 'What is the artifact version?')
        string(name: 'environment', defaultValue: '', description: 'What is the environment?')
        string(name: 'action', defaultValue: 'apply', description: 'Action to perform (apply/destroy)')
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
            when {
                expression { params.action == 'destroy' }
            }
            input {
                message 'Should we continue?'
                ok 'Yes, we should.'
            }
            steps {
                sh """
                    cd terraform
                    terraform destroy -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}" -auto-approve
                """
            }
        }
        stage('Apply') {
            when {
                expression { params.action == 'apply' }
            }
            steps {
                sh """
                    cd terraform
                    terraform apply -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}" -auto-approve
                """
            }
        }
    }
    post { 
        always { 
            echo 'Pipeline finished.'
            deleteDir()
        }
        failure {
            echo 'Pipeline failed. Please review.'
        }
        success {
            echo 'Pipeline completed successfully.'
        }
    }
}
