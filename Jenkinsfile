#!groovy

pipeline {
    agent { 
		node {
			label 'VirtualBox-6.0'
		} 
	}
    tools { }

    stages {
     	stage('Validate') {
    		steps {
				sh 'pwd && ls -lah'
				sh 'packer validate ubuntu1804.json'
			}
		}
		stage('Build') {
    		steps {
				sh 'packer build -var "version=${BUILD_NUMBER}" ubuntu1804.json'
			}
		  }
    }
    
    post {
		success {
		//	archiveArtifacts artifacts: 'target/*.jar, target/*.tgz', fingerprint: true
		}
    }
}
