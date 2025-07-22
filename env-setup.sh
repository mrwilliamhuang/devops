#!/bin/bash
set -e  # 在任何错误时退出

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 加载配置
source "${SCRIPT_DIR}/config.sh" || { echo "加载配置失败，退出"; exit 1; }

# 设置 Jenkins CLI 命令
JENKINS_CLI="java -jar \"${SCRIPT_DIR}/jenkins-cli.jar\" -s \"${JENKINS_URL}\" -auth \"${CREDENTIALS}\""