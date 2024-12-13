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
