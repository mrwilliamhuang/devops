# DevOps 自动化部署指南

## 项目概述

提供Jenkins自动化管理与部署能力，简化DevOps流程。支持创建Jenkins任务、触发构建、参数化部署等功能。

## 项目目录结构

```
.
├── config.sh                 # Jenkins连接信息和认证凭据配置
├── deploy.sh                 # 主部署脚本，支持参数化项目部署
├── env-setup.sh              # 环境设置相关脚本
├── jenkins.sh                # Jenkins任务管理入口脚本
└── readme.md                 # 项目文档
```

## 快速开始

### 环境准备
1. 安装Java运行时环境
2. 配置Jenkins CLI
3. 确保Bash shell可用

### Jenkins配置

#### 创建Jenkins任务
```bash
# 创建deploy-api任务（用于mfsapi项目）
./jenkins.sh create-job mfsapi

# 创建deploy-web任务（用于mfsweb项目）
./jenkins.sh create-job mfsweb
```

#### 触发构建
```bash
# 触发 mfsapi 构建
./jenkins.sh trigger mfsapi

# 触发 mfsweb 构建
./jenkins.sh trigger mfsweb
```

## 部署说明

### 部署结构
- `~/production/mfsapi`: 从 `~/repo/mfsapi` 部署
- `~/production/mfsweb`: 从 `~/repo/mfsweb` 部署

### 部署脚本使用方法
```bash
# 部署mfsapi项目
./deploy.sh mfsapi

# 部署mfsweb项目
./deploy.sh mfsweb
```

## 配置管理

### config.sh - 公共配置文件

```bash
# Jenkins 连接配置
JENKINS_URL="http://localhost:8080"
JENKINS_USER="admin"
JENKINS_TOKEN="your_api_token"
JENKINS_CLI_PATH="~/jenkins-cli.jar"
```

> 注意：该文件包含敏感信息，应妥善保管并设置适当的文件权限

## 安全注意事项
1. config.sh包含敏感信息，应设置适当的文件权限（建议600）
2. 确保脚本文件具有适当的执行权限（建议755）
3. 所有脚本都应包含必要的参数验证和错误处理机制
4. 运行脚本的用户应遵循最小权限原则

## 常见问题解决方案

### 问题1：执行脚本时出现"权限拒绝"错误
**解决方法**：确保脚本文件具有执行权限，使用以下命令设置权限：
```bash
chmod +x <脚本文件名>
```

### 问题2：Jenkins连接失败
**解决方法**：
1. 检查Jenkins服务是否正在运行
2. 验证config.sh中的JENKINS_URL配置是否正确
3. 确认Jenkins用户凭据和API Token是否正确