#!/bin/bash

# 检查是否提供了项目名称
if [ -z "$1" ]; then
    echo "请指定项目名"
    echo "用法: $0 <项目名>"
    exit 1
fi

# 设置脚本目录
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 加载配置
source "${SCRIPT_DIR}/config.sh" || { echo "错误: 加载配置失败"; exit 1; }

# 根据项目名选择部署脚本
case "$1" in
    "mfsapi")
        ${SCRIPT_DIR}/deploy-api.sh "mfsapi"
        ;;
    "mfsweb")
        ${SCRIPT_DIR}/deploy-web.sh "mfsweb"
        ;;
    *)
        echo "错误: 不支持的项目类型: $1"
        echo "用法: $0 <项目名> (mfsapi|mfsweb)"
        exit 1
        ;;
esac

# 退出状态码传递
exit $?