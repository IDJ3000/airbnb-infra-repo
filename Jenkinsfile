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
               
                sh 'sudo yum install python3-pip'           // Install the package python3-pip 
                sh 'sudo yum remove python3-requests'      // Remove the package python3-requests already with the AMI
                sh 'sudo pip3 install requests'            // Use pip3 to install the package called requests  
                sh 'sudo pip3 install checkov'             // Use pip3 to install the package called checkov   
                sh 'checkov -d . --skip-check CKV_AWS_79,CKV2_AWS_41'   // use checkov to scan the terraform code
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
            echo 'I will always say Hello!'
            slackSend channel: '#jjtech-champions-devops-team', color: COLOR_MAP[currentBuild.currentResult], message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL} \n Build By: Precious" 
        }
    }
}
