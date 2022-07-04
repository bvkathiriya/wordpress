pipeline {
    
       

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        git branch: 'main', url: 'https://github.com/bvkathiriya/wordpress.git'
      }
    }
      
     stage('Build Docker Image'){
            steps{
                 sh 'docker version'
                 sh 'docker image prune -af --filter "until=24h"'
                 sh 'docker build -t wordpress .'
                 sh 'docker image list'
                 sh 'docker tag wordpress kathiriya007/wordpress:$BUILD_NUMBER'
            }
        } 
        stage('docker image Push'){
            steps{
                withCredentials([string(credentialsId: 'DOCKER_HUB_PASSWORD', variable: 'PASSWORD')]) {
                 sh 'docker login -u kathiriya007  -p $PASSWORD'
                 sh 'docker push kathiriya007/wordpress:$BUILD_NUMBER'
                }
            }    
        

        } 
      
        stage('Cleaning up') {
            steps{
                sh 'docker rmi kathiriya007/wordpress:$BUILD_NUMBER'
                sh 'docker image prune -af --filter "until=24h"'
                sh 'sed -i "s/<TAG>/${BUILD_NUMBER}/" wordpress-deployment.yaml'
            }
        }
    

   #stage('Deploy to K8s') {
     # steps {
       # withKubeConfig([credentialsId: 'kubernetes']) { 
        #  sh 'kubectl delete all --all'  
          #sh 'sed -i "s/<TAG>/${BUILD_NUMBER}/" wordpress-deployment.yaml'
          
          #sh 'kubectl apply -f ./ --validate=false'
          
      #  }
    #  } 
   # }


  }
}
