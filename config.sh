#!/bin/bash

# Jenkins 配置
JENKINS_URL="http://localhost:8080"  # Jenkins 服务器地址
CREDENTIALS="admin:117da142c44ded4a074184d80600e1a304"  # Jenkins 认证信息（用户名:API token）

# 项目部署配置
REPO_DIR="~/repo"  # 代码仓库根目录
PRODUCTION_DIR="~/production"  # 生产环境部署目录

# 日志配置
LOG_DIR="${SCRIPT_DIR}/logs"  # 日志文件目录
LOG_LEVEL="INFO"  # 日志级别：DEBUG, INFO, WARN, ERROR

# 创建日志目录（如果不存在）
mkdir -p "${LOG_DIR}"