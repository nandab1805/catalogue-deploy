pipeline {
    agent {
        node {
            label 'Agent'
        }
    }
    // environment { 
    //     packageVersion = ''
    //     nexusURL = '172.31.91.191:8081'
    // }
    options {
        timeout(time: 1, unit: 'HOURS') 
        disableConcurrentBuilds()
        ansiColor('xterm')
    }
     parameters {
        string(name: 'version', defaultValue: '', description: 'what is artifact version?')
        string(name: 'environment', defaultValue: '', description: 'what is environment?')

    }
    stages {
        stage('Print version') {
            steps {
                sh"""
                    echo "version: ${params.version}"                
                    echo "envinorment: ${params.environment}"

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
        stage('apply') { 
            steps {
                sh """
                    cd terraform
                    terraform apply -var-file=${params.environment}/${params.environment}.tfvars -var="app_version=${params.version}" -auto-approve                 
                """
            }
        }
        stage('Destroy') {
            when {
                expression { 
                    params.action == 'destroy'
                }
            }
            input {
                message "Should we continue?"
                ok "Yes, we should."
                // submitter "alice,bob"
                // parameters {
                //     string(name: 'PERSON', defaultValue: 'Mr Jenkins', description: 'Who should I say hello to?')
                // }
            }
            steps {
                sh """
                    cd terraform
                    terraform destroy -auto-approve
                """
            }
        }
    }
    post { 
        always { 
            echo 'I will always say Hello again and again!'
            deleteDir()
        }
        failure {
            echo 'This runs when the pipeline fails, used generally to send some alerts.'
        }
        success {
            echo 'I will say Hello when the pipeline is successful.'
        }
    }
}
