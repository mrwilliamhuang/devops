#!/bin/bash

PROJECT=${1:-mfsapi}
JENKINS_URL="http://localhost:8080"
CREDENTIALS="${JENKINS_CREDENTIALS:-admin:117da142c44ded4a074184d80600e1a304}"
JOB_NAME="deploy-job"
JENKINSFILE_PATH="/home/william/repo/devops/Jenkinsfile"

send_curl() {
  local resp=$(curl -s -w "\n%{http_code}" -X "${3:-POST}" -u "$CREDENTIALS" "$1" -H "Content-Type: ${4:-application/xml}" --data-binary "$2")
  [ $(echo "$resp" | tail -n 1) -ge 200 ] && [ $(echo "$resp" | tail -n 1) -lt 300 ] || { echo "Err: $(echo "$resp" | head -n -1)"; return 1; }
  return 0
}

[ -f "$JENKINSFILE_PATH" ] || { echo "Err: Jenkinsfile not found"; exit 1; }

send_curl "${JENKINS_URL}/job/${JOB_NAME}/doDelete" "" DELETE "text/html"
XML_DATA="<flow-definition><definition class=\"org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition\" plugin=\"workflow-cps@latest\"><script>$(cat $JENKINSFILE_PATH)</script><sandbox>true</sandbox></definition></flow-definition>"
send_curl "${JENKINS_URL}/createItem?name=${JOB_NAME}" "$XML_DATA" || exit 1
send_curl "${JENKINS_URL}/job/${JOB_NAME}/buildWithParameters?PROJECT=$PROJECT" "" || exit 1

echo "Jenkins job $JOB_NAME created and triggered."
