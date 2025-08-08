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
# 从环境变量获取认证信息，若未设置则使用默认值
CREDENTIALS="${JENKINS_CREDENTIALS:-admin:117da142c44ded4a074184d80600e1a304}"  
JOB_NAME="deploy-job"  # 作业名称
JENKINSFILE_PATH="/home/william/repo/devops/Jenkinsfile"  # Jenkinsfile 文件路径

# 封装 curl 请求函数
function send_curl_request {
  local url="$1"
  local data="$2"
  local method="${3:-POST}"
  local content_type="${4:-application/xml}"

  echo "正在发送 $method 请求到 $url"
  local response=$(curl -s -w "\n%{http_code}" -X "$method" -u "$CREDENTIALS" "$url" \
    -H "Content-Type: $content_type" \
    --data-binary "$data")
  local http_code=$(echo "$response" | tail -n 1)
  local body=$(echo "$response" | head -n -1)

  if [ "$http_code" -lt 200 ] || [ "$http_code" -ge 300 ]; then
    echo "错误: 请求失败，HTTP 状态码 $http_code，响应内容: $body"
    return 1
  fi
  return 0
}

# 检查 Jenkinsfile 是否存在
if [ ! -f "$JENKINSFILE_PATH" ]; then
  echo "错误: Jenkinsfile 不存在于 $JENKINSFILE_PATH"
  exit 1
fi

# 删除旧的 Jenkins 作业
echo "尝试删除旧的 Jenkins 作业: $JOB_NAME"
send_curl_request "${JENKINS_URL}/job/${JOB_NAME}/doDelete" "" DELETE "text/html"
# 即便删除失败，也继续执行后续操作，因为可能作业本身不存在
echo "旧作业删除操作完成，继续后续流程"

# 创建新的 Jenkins 作业
echo "创建新的 Jenkins 作业: $JOB_NAME"
JENKINSFILE_CONTENT=$(cat "$JENKINSFILE_PATH")
XML_DATA="<flow-definition><definition class=\"org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition\" plugin=\"workflow-cps@latest\"><script>$JENKINSFILE_CONTENT</script><sandbox>true</sandbox></definition></flow-definition>"
if ! send_curl_request "${JENKINS_URL}/createItem?name=${JOB_NAME}" "$XML_DATA"; then
  exit 1
fi

# 触发作业构建
echo "触发作业构建: $JOB_NAME"
if ! send_curl_request "${JENKINS_URL}/job/${JOB_NAME}/buildWithParameters?PROJECT=$PROJECT" ""; then
  exit 1
fi

echo "Jenkins 作业已成功创建并触发构建: $JOB_NAME"