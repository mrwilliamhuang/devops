#!/bin/bash

# 参数验证：检查是否提供了项目名称参数
if [ -z "$1" ]; then
  PROJECT="mfsapi"  # 默认项目
  echo "使用默认项目: $PROJECT"
else
  PROJECT="$1"
  echo "使用指定项目: $PROJECT"
fi

# Jenkins 配置
JENKINS_URL="http://localhost:8080"  # Jenkins 服务器地址
CREDENTIALS="admin:117da142c44ded4a074184d80600e1a304"  # Jenkins 认证信息（用户名:API token）
JOB_NAME="deploy-job"  # 作业名称
JENKINSFILE_PATH="/home/william/repo/devops/Jenkinsfile"  # Jenkinsfile 文件路径

# 检查 Jenkinsfile 是否存在
if [ ! -f "$JENKINSFILE_PATH" ]; then
  echo "错误: Jenkinsfile 不存在于 $JENKINSFILE_PATH"
  exit 1
fi

# 创建或更新 Jenkins 作业
echo "创建或更新 Jenkins 作业: $JOB_NAME"
curl -X POST -u "$CREDENTIALS" "${JENKINS_URL}/createItem?name=${JOB_NAME}" \
  -H "Content-Type: application/xml" \
  --data-binary "<flow-definition><definition class=\"org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition\" plugin=\"workflow-cps@latest\"><script>$(cat $JENKINSFILE_PATH)</script><sandbox>true</sandbox></definition></flow-definition>"

# 检查 curl 命令是否执行成功
if [ $? -ne 0 ]; then
  echo "错误: 无法创建或更新 Jenkins 作业"
  exit 1
fi

# 触发作业构建
echo "触发作业构建: $JOB_NAME"
curl -X POST -u "$CREDENTIALS" "${JENKINS_URL}/job/${JOB_NAME}/buildWithParameters?PROJECT=$PROJECT"

# 检查 curl 命令是否执行成功
if [ $? -ne 0 ]; then
  echo "错误: 无法触发作业构建"
  exit 1
fi

echo "Jenkins 作业已成功创建并触发构建: $JOB_NAME"