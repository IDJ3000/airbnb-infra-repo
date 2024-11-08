def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
    ]

pipeline {
    agent any
    
    tools {
        terraform 'Terraform'
    }
    
     environment {
        AWS_ACCESS_KEY_ID     = credentials('jenkins-aws-secret-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('jenkins-aws-secret-access-key')
    }

    stages {
        stage('Git Check') {
            steps {
                echo 'Cloning project code into jenkins'
                git branch: 'main', credentialsId: 'github-login', url: 'https://github.com/IDJ3000/airbnb-infra-repo.git'
                sh 'ls'
            }
        }
        
        stage('Terraform Version') {
            steps {
                echo 'Verrifying terraform verrion'
                sh 'terraform --version'
            }
        }
        
       stage('Terraform init') {
            steps {
                echo 'terraform initialization of project'
                sh 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                echo 'Running terraform plan'
                sh 'terraform plan'
            }
        }
        
        stage('Checkov scan') {
    steps {
        sh """
        sudo yum update -y
        sudo yum install python3 -y
        if ! command -v pip3 &> /dev/null
        then
            echo 'Installing pip3...'
            sudo yum install python3-pip -y
        fi
        sudo pip3 install checkov
        checkov -d .
        """
    }
}

        stage('Terraform Apply') {
            steps {
                echo 'Running terraform apply'
                sh 'terraform ${action} --auto-approve'
            }
        }
        
    }
    
     post { 
        always { 
            echo 'I will always say Hello again!'
            slackSend channel: '#jjtech-champions-devops-team', color: COLOR_MAP[currentBuild.currentResult], message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"
        }
    }
}
