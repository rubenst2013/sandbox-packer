#!groovy

pipeline {
    agent { 
		node {
			label 'virtualbox-6.0'
		} 
	}

	environment {
        PACKER_CACHE_DIR = '/usr/local/share/packer/cache/'
    }

    stages {
     	stage('Validate') {
    		steps {
				sh 'pwd && ls -lah'
				sh 'packer validate ubuntu-server.json'
			}
		}
		stage('Build') {
    		steps {
				sh 'packer build -var "version=${TAG_NAME:-b${BUILD_NUMBER}}" -var "build_number=b${BUILD_NUMBER}" -var "branch_name=${BRANCH_NAME}" ubuntu-server.json'
			}
		}
		stage('Upload') {
      when {
		    allOf {
		      tag comparator: "REGEXP", pattern: "^(0|[1-9]\\d*)\\.(0|[1-9]\\d*)\\.(0|[1-9]\\d*)(?:-((?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+([0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?\$"
		    }
		    beforeOptions true
        beforeInput true
        beforeAgent true
		  }
			steps {
				withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: '4f42c8d2-3c58-4093-b7da-bdc8df4e5fcc',
				usernameVariable: 'NEXUS_USERNAME', passwordVariable: 'NEXUS_PASSWORD']]) {

					sh '''
						nexus_host="nexus3-test.es.gk-software.com"
						nexus_repo_base_url="https://${nexus_host}/nexus/repository"
						nexus_repo="vagrant"
						nexus_repo_sub_dir="boxes/custom/rsteinbacher/ubuntu-server"
						box_file_location="./builds"
						box_file_name="virtualbox-ubuntu-server-${TAG_NAME}.box"
						box_file_size_in_bytes=$(ls -nl "${box_file_location}/${box_file_name}" | awk '{print $5}')

						echo "Uploading file ${box_file_name} to ${nexus_repo_base_url}/${nexus_repo}/${nexus_repo_sub_dir}/${box_file_name}"

						curl --request PUT \
							--user "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" \
							--upload-file "${box_file_location}/${box_file_name}" \
							--url "${nexus_repo_base_url}/${nexus_repo}/${nexus_repo_sub_dir}/${box_file_name}" \
							--connect-timeout 5 \
							--max-time 2000 \
							--header "Accept: */*" \
							--header "Accept-Encoding: gzip, deflate" \
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

	post {
		always {
			deleteDir() /* clean up our workspace */
		}
	}
}
