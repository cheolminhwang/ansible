
JENKINS_URL=$1
JENKINS_USER=$2
JENKINS_PASSWORD_OR_TOKEN=$3

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

###List Tokens
groovy_script="
    import jenkins.security.ApiTokenProperty
    import hudson.model.User
    def tokens = [:]
    user = User.get('jenkins',false)
        def apiTokenProperty = user.getProperty(ApiTokenProperty.class)
        if (apiTokenProperty) {
            tokens[user.id] = apiTokenProperty.tokenStore.tokenList.collectEntries { token ->
                [token.uuid, token.name]
            }
        }
    println(groovy.json.JsonOutput.prettyPrint(groovy.json.JsonOutput.toJson(tokens)))
  "

TOKENS=$(curl -s -X POST \
    --cookie /tmp/cookies --user "$JENKINS_USER:$JENKINS_PASSWORD_OR_TOKEN" \
    --data "script=${groovy_script}" \
    -H "Jenkins-Crumb:$CRUMB2" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    "$JENKINS_URL/scriptText")

echo "$TOKENS"
