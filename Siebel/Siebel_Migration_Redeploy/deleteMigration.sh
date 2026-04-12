#!/bin/bash
while getopts u:p:a:b:d:e:f:g:h: option
do
 case "${option}"
 in
 u)  USER=${OPTARG};;
 p)  PASS=${OPTARG};;
 a)  SAIHOST=${OPTARG};;
 b)  SAIPORT=${OPTARG};;
 d)  PROFILE=${OPTARG};;
 e)  MNAME=${OPTARG};;
 f)  MDESC=${OPTARG};;
 g)  SRVHOST=${OPTARG};;
 h)  SRVPORT=${OPTARG};;
  esac
done
ENCODED="$(echo $USER:$PASS|base64)"

JSON='{
"DeploymentInfo":
{
"PhysicalHostIP":"'$SRVHOST':'$SRVPORT'",
"ProfileName":"'$PROFILE'",
"Action":"Deploy"
},
"MigrationDeployParams":
{
"SiebelMigration":"'$MNAME'",
"MigrationDesc":"'$MDESC'"
}
}'

echo
echo $JSON
echo

echo $JSON |  curl -v  -k -H "Content-Length: ${#JSON}"  \
 -H "Authorization: Basic $ENCODED" \
 -H "Content-Type: application/json" \
 -X DELETE \
https://$SAIHOST:$SAIPORT/siebel/v1.0/cloudgateway/deployments/migrations/$PROFILE \
-d @-

