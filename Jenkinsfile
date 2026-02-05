pipeline {
    agent {
		node{
			label 'built-in'
			customWorkspace '/var/jenkins_home/workspace/ansible'
		}
	}
    environment {       
	   def resulttxt = ""
    }

    stages {		 
		stage('Cleanup') {
            steps {
                cleanWs()  // Deletes workspace contents
            }
        }
		stage('Checkout') {
			steps {
				checkout scm
			}			
        }

		stage('Git Clone of Siebel repository') {
			steps {
				script {
					withCredentials([string(credentialsId: 'patMine', variable: 'TOKEN')]) { 
						def response = sh(
                            script: """
								git clone --filter=blob:none --sparse https://x-token-auth:${TOKEN}@github.com/cheolminhwang/ansible.git --branch br1
						    	cd ansible
                                git sparse-checkout set DirA                   
                            """,
                            returnStdout: true
                        ).trim() 
                        echo "response:${response}"               
						
					}
				}
			}
	  	}
        stage('Ansible') {
            steps{
                withCredentials([usernamePassword(credentialsId: 'jenkins', usernameVariable: 'J_USER', passwordVariable: 'J_PASS')]) {
                    /*script {
                        def result = sh(
                            script: """
                            ANSIBLE_STDOUT_CALLBACK=json ansible-playbook \
                            -i ${WORKSPACE}/Jenkins_Maint/ansible/inventory/hosts.yml \
                            ${WORKSPACE}/Jenkins_Maint/ansible/list.yml \
                            -e "env=${env.Environment}" -e "user=jenkins" \
                            -e "token=${J_PASS}"  -e "workspace=/persistent"
                            """,
                            returnStdout: true
                        ).trim()  
                    def jsonObject = readJSON text: result
                    echo "Playbook ran for : ${jsonObject.plays[0].tasks[2].hosts.nonprod.files[0].path}"
                    def jsonContent = jsonObject.plays[0].tasks[2].hosts.nonprod.files
                    jsonContent.each { item ->
                        echo "Processing ${item.path}"
                    }  
    
                        echo "Playbook ran : ${result}"
                        resulttxt = "${jsonObject}"
                    */
                    ansiblePlaybook(
                        playbook: "${WORKSPACE}/Jenkins_Maint/ansible/list.yml",
                        inventory: "${WORKSPACE}/Jenkins_Maint/ansible/inventory/hosts.yml",
                        credentialsId: 'jenkins_private_key',
                        colorized: true,
                        extraVars: [
                            env: "${env.Environment}",
                            user: "jenkins",
                            token: "${J_PASS}",
                            target_dir: "/tmp/data",
                            workspace: "/persistent"
                        ]
                    )
                    script {
                        if (fileExists('found_files.json')) {
                            def filesList = readJSON file: 'found_files.json'
                    
                            // Now you can use the file names in Jenkins
                            filesList.each { fileName ->
                                echo "Found file: ${fileName}"
                            }
                        }
                    }
                }
             
                 
                //echo "resulttxt:${resulttxt}"    
            }

        }
    }
}
