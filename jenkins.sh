#!/bin/bash

# 参数检查
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <Jenkinsfile路径>"
    exit 1
fi

JENKINSFILE=$1
JENKINS_URL="http://localhost:8080"
JOB_NAME="mfsapi-deploy"
CREDENTIALS="admin:119eb822b5b1f69a5b06184c16bdeeaed1"

# 检查文件是否存在
if [ ! -f "$JENKINSFILE" ]; then
    echo "错误: 文件 $JENKINSFILE 不存在"
    exit 1
fi

# 检查Jenkins服务是否可用
if ! curl -s --head "${JENKINS_URL}" >/dev/null; then
    echo "错误: 无法连接到Jenkins服务器"
    exit 1
fi

# 检查任务是否存在
check_job() {
    curl -s -o /dev/null -w "%{http_code}" "${JENKINS_URL}/job/${JOB_NAME}/" --user "${CREDENTIALS}"
}

# 创建任务
create_job() {
    echo "正在创建Jenkins任务: ${JOB_NAME}"
    CRUMB=$(curl -s "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)" --user "${CREDENTIALS}")
    curl -s -X POST "${JENKINS_URL}/createItem?name=${JOB_NAME}" \
        --user "${CREDENTIALS}" \
        -H "$CRUMB" \
        -H "Content-Type:application/xml" \
        --data-binary @<(cat <<EOF
<?xml version='1.0' encoding='UTF-8'?>
<flow-definition plugin="workflow-job">
  <actions/>
  <description/>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps">
    <scm class="hudson.plugins.git.GitSCM" plugin="git">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>file://$(pwd)</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>${JENKINSFILE}</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF
)
}

# 检查并创建任务
if [ "$(check_job)" != "200" ]; then
    create_job
    sleep 3 # 等待任务创建完成
fi

# 触发构建
echo "正在使用 $JENKINSFILE 触发Jenkins构建..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST "${JENKINS_URL}/job/${JOB_NAME}/build" \
    --user "${CREDENTIALS}" \
    --form "file0=@${JENKINSFILE}" \
    --form json='{"parameter": [{"name":"JENKINSFILE", "file":"file0"}]}')

# 检查响应
if [ "$RESPONSE" = "201" ]; then
    echo "成功触发Jenkins构建"
    echo "构建详情: ${JENKINS_URL}/job/${JOB_NAME}/lastBuild"
else
    echo "触发构建失败，HTTP状态码: $RESPONSE"
    exit 1
fi