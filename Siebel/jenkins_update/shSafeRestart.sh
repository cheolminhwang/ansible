JENKINS_URL=$1
JENKINS_USER=$2
JENKINS_PASSWORD_OR_TOKEN=$3

JENKINS_CLI=./jenkins-cli.jar

# CRUMB
CRUMB=$(curl -s --cookie-jar /tmp/cookies -u "$JENKINS_USER:$JENKINS_PASSWORD_OR_TOKEN" \
    "$JENKINS_URL/crumbIssuer/api/json" |
    grep -Eo '"crumb"[^,]*' | grep -Eo '[^:]*$')
### jq -r '.crumb')

### echo "Generated CRUMB: $CRUMB"
CRUMB2=$(echo $CRUMB | sed 's/"//g')

TOKENS=$(curl -s -X POST \
    --cookie /tmp/cookies --user "$JENKINS_USER:$JENKINS_PASSWORD_OR_TOKEN" \
    -H "Jenkins-Crumb:$CRUMB2" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    "$JENKINS_URL/safeRestart")

echo "$TOKENS"
