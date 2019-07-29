#!groovy

pipeline {
    agent { 
		node {
			label 'virtualbox-6.0'
		} 
	}

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

}
