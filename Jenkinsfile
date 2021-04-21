
pipeline {
  agent any
  triggers{
      githubPush()
  }
  stages {
    stage('fetch'){
        steps{
            git branch: 'cicd', url: 'https://github.com/bjammal/learning-labs.git'
        }
    }
    stage('build') {
        steps {
          withCredentials([
            usernamePassword(credentialsId: 'jenkins-aws-secret', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
          ]) {
            sh '''
              cd packer/aws
              packer build apache.pkr.hcl
              '''
        }
      }
    }
    stage('AWS-deploy') {
      steps {
          withCredentials([
            usernamePassword(credentialsId: 'jenkins-aws-secret', passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')
          ]) {
            sh '''
               cd terraform/aws
               terraform init
               terraform apply -auto-approve
            '''
        }
      }
    }
  }
}
