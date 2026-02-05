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
                    script {
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
                        def jsonString = '''
                      {
                        "key": "value",
                        "status": "active"
                      }
                    '''
                    // Parse the JSON string
                    def jsonObject = readJSON text: jsonString
                    
                        echo "Playbook ran : ${result}"
                        resulttxt = "${result}"
                        /*ansiblePlaybook(
                            playbook: "${WORKSPACE}/Jenkins_Maint/ansible/list.yml",
                            inventory: "${WORKSPACE}/Jenkins_Maint/ansible/inventory/hosts.yml",
                            credentialsId: 'jenkins_private_key',
                            colorized: true,
                            extraVars: [
                                env: "${env.Environment}",
                                user: "jenkins",
                                token: "${J_PASS}",
                                workspace: "/persistent"
                            ]
                        )*/
                    }
                }
                echo "resulttxt:${resulttxt}"   
            }

        }
    }
}
