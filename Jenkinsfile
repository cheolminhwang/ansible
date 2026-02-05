pipeline {
    agent {
		node{
			label 'built-in'
			customWorkspace '/tmp/AA'
		}
	}

    stages {		 
		stage('Checkout') {
			steps {
				checkout scm
			}			
        }

		stage('Git Clone of Siebel repository') {
			steps {
				script {
					withCredentials([string(credentialsId: 'patMine', variable: 'TOKEN')]) {
						sh("git clone https://x-token-auth:${TOKEN}@github.com/cheolminhwang/ansible.git --branch br1")
						/*def response = sh(
                            script: """
								git clone --filter=blob:none --sparse https://x-token-auth:${TOKEN}@github.com/cheolminhwang/ansible.git --branch br1")
						    	cd sbl_code_repo
                                git sparse-checkout set DeploymentArtifacts                   
                            """,
                            returnStdout: true
                        ).trim() 
                        echo "response:${response}"               
						*/
					}
				}
			}
	  	}
/*            steps{
                withCredentials([usernamePassword(credentialsId: 'jenkins-username-password', usernameVariable: 'J_USER', passwordVariable: 'J_PASS')]) {
                    ansiColor('xterm') {
                        ansiblePlaybook(
                            playbook: "${WORKSPACE}/Jenkins_Maint/ansible/update.yml",
                            inventory: "${WORKSPACE}/Jenkins_Maint/ansible/inventory/hosts.yml",
                            credentialsId: 'jenkins_private_key',
                            colorized: true,
                            extraVars: [
                                env: "${env.Environment}",
                                user: "jenkins",
                                token: "${J_PASS}",
                                workspace: "${WORKSPACE}"
                            ]
                        )
                    }
                }
            }
			
       }
*/
    }
}
