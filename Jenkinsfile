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

	post {
		success {
			withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '4f42c8d2-3c58-4093-b7da-bdc8df4e5fcc',
				usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD']]) {

				sh '''
					nexus_host="nexus3-test.es.gk-software.com"
					nexus_repo_base_url="https://${nexus_host}/nexus/repository"
					nexus_repo="vagrant"
					nexus_repo_sub_dir="boxes/custom/rsteinbacher/ubuntu1804"
					basic_auth="Basic dmFncmFudDp0cTZuRTQ1U0NlS1hJ"
					box_file_location="./builds"
					box_file_name="virtualbox-ubuntu1804-${BUILD_NUMBER}.box"
					box_file_size_in_bytes="$(ls -nl ${box_file_location}/${box_file_name} | awk '{print $5}')"

					echo "Uploading file ${box_file_name} to ${nexus_repo_base_url}/${nexus_repo}/${nexus_repo_sub_dir}/${box_file_name}

					curl --request PUT \
						--user "${NEXUS_USERNAME}:${NEXUS_PASSWORD}"
						--upload-file "${box_file_location}/${box_file_name}" \
						--url "${nexus_repo_base_url}/${nexus_repo}/${nexus_repo_sub_dir}/${box_file_name}" \
						--connect-timeout 5 \
						--max-time 2000 \
						--header "Accept: */*" \
						--header "Accept-Encoding: gzip, deflate" \
						--header "Authorization: ${basic_auth}" \
						--header "Cache-Control: no-cache" \
						--header "Connection: keep-alive" \
						--header "Content-Length: ${box_file_size_in_bytes}" \
						--header "Content-Type: application/octet-stream" \
						--header "Host: ${nexus_host}" \
						--verbose

					echo "Upload completed"
				'''
			}
		}
	}
}
