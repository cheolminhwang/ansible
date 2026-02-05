pipeline {
    agent {
		node{
			label 'built-in'
			customWorkspace '/var/jenkins_home/workspace/ansible'
		}
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
                    ansiColor('xterm') {
                        ansiblePlaybook(
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
                        )
                    }
                }
            }
        }
    }
}
