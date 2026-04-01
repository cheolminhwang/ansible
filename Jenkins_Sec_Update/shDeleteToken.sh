if [ "$#" -ne 5 ]; then
 echo "Usage: $0 <arg1> <arg2> <arg3> <arg4:username> <arg5:tokenname>"
 exit 1
fi
echo "You provided $# arguments."


JENKINS_URL=$1
JENKINS_USER=$2
JENKINS_PASSWORD_OR_TOKEN=$3
#JENKINS_URL="https://build-nonp.dhsie.hawaii.gov"
#JENKINS_USER="CHWANG1"
#JENKINS_PASSWORD_OR_TOKEN='S$9L2nCn1g'

##wget https://build-oci.dhsie.hawaii.gov/jnlpJars/jenkins-cli.jar
JENKINS_CLI=./jenkins-cli.jar

# CRUMB
CRUMB=$(curl -s --cookie-jar /tmp/cookies -u "$JENKINS_USER:$JENKINS_PASSWORD_OR_TOKEN" \
    "$JENKINS_URL/crumbIssuer/api/json" | 
    grep -Eo '"crumb"[^,]*' | grep -Eo '[^:]*$')
### jq -r '.crumb')

### echo "Generated CRUMB: $CRUMB"
CRUMB2=$(echo $CRUMB | sed 's/"//g')
##echo "Generated CRUMB2: $CRUMB2"


#AUTH="$JENKINS_USER:115f3c64203ee8fa5d0c34ed6e71b08f2c"
#AUTH="$JENKINS_USER:116da23aab3c60b8a51e0459da4a63562a"
###List Tokens
username=$4
tokenName=$5
groovy_script="""
import jenkins.model.Jenkins
import hudson.model.User
import jenkins.security.ApiTokenProperty

def revokeSpecificToken(String username, String tokenName) {
    def user = User.getById(username, false)
    if (user == null) {
        println \"User '${username}' not found\"
        return false
    }

    def apiTokenProperty = user.getProperty(ApiTokenProperty.class)
    if (apiTokenProperty == null) {
        println \"User '${username}' has no API tokens\"
        return false
    }

    def tokenStore = apiTokenProperty.getTokenStore()
    def tokens = tokenStore.getTokenListSortedByName()
    def targetToken = tokens.find { it.name == tokenName }

    if (targetToken == null) {
        println \"Token '${tokenName}' not found for user '${username}'\"
        return false
    }

    println \"Revoking token '${tokenName}' for user '${username}'\"
    tokenStore.revokeToken(targetToken.uuid)
    user.save()

    println \"Successfully revoked token '${tokenName}' for user '${username}'\"
    return true
}
def targetUser = \"${username}\" 
def tokenName = \"${tokenName}\"

//println \"n=== Revoking token ===\"
revokeSpecificToken(targetUser,tokenName)
  """

TOKENS=$(curl -s -X POST \
    --cookie /tmp/cookies --user "$JENKINS_USER:$JENKINS_PASSWORD_OR_TOKEN" \
    --data "script=${groovy_script}" \
    -H "Jenkins-Crumb:$CRUMB2" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    "$JENKINS_URL/scriptText")

echo "$TOKENS"
