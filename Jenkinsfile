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
                 sh 'docker build -t wordpress .'
                 sh 'docker image list'
                 sh 'docker image prune -af --filter "until=24h"'
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
            }
        }
    

   stage('Deploy to K8s') {
      steps {
        withKubeConfig([credentialsId: 'kubernetes']) { 
          sh 'sed -i "s/<TAG>/${BUILD_NUMBER}/" deployments_wp.yaml'
          sh 'kubectl apply -f deployments_wp.yaml  --validate=false'
          sh 'kubectl apply -f mysql_deployment.yml'
          sh 'kubectl -f mysql-pv.yaml'
          sh 'kubectl -f mysql-pvc.yaml'
          sh 'kubectl -f mysql_svc.yaml'
          sh 'kubectl -f secrets.yml'
          sh 'kubectl -f wp-pv.yaml'
          sh 'kubectl -f wp-pvc.yaml'
          sh 'kubectl -f wp_svc.yaml'
          
        }
      } 
    }


  }
}
