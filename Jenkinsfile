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
    }
     parameters {
        string(name: 'version', defaultValue: '1.0.0', description: 'what is artifact version?')
        string(name: 'envinorment', defaultValue: 'dev', description: 'what is envinorment?')

    }
    stages {
        stage('Print version') {
            steps {
                sh"""
                    echo "version: ${params.version}"                
                    echo "envinorment: ${params.envinorment}"

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
