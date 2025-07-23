#!/bin/bash

# Jenkins 配置
JENKINS_URL="http://localhost:8080"  # Jenkins 服务器地址
CREDENTIALS="admin:117da142c44ded4a074184d80600e1a304"  # Jenkins 认证信息（用户名:API token）
JOB_NAME="deploy-job"  # 作业名称
JENKINSFILE_PATH="/home/william/repo/devops/Jenkinsfile"  # Jenkinsfile 文件路径

# 创建或更新 Jenkins 作业
curl -X POST -u "$CREDENTIALS" "${JENKINS_URL}/createItem?name=${JOB_NAME}" \
  -H "Content-Type: application/xml" \
  --data-binary "<flow-definition><definition class=\"org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition\" plugin=\"workflow-cps@latest\"><script>$(cat $JENKINSFILE_PATH)</script><sandbox>true</sandbox></definition></flow-definition>"

# 触发作业构建，默认部署 mfsapi，可按需修改 PROJECT 参数
curl -X POST -u "$CREDENTIALS" "${JENKINS_URL}/job/${JOB_NAME}/buildWithParameters?PROJECT=mfsapi"