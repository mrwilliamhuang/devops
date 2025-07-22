#!/bin/bash

# 设置脚本目录
SCRIPT_DIR=$(cd "$(dirname \"$0\")" && pwd)

# 加载公共函数
source "${SCRIPT_DIR}/env-setup.sh" || exit 1
k
# 主程序
if [ -z "$1" ]; then
    echo "请指定命令"
    echo "用法: $0 <命令> [参数]"
    echo "命令: build"
    exit 1
fi

COMMAND=$1
shift

# 检查项目名称
if [ -z "$1" ]; then
    echo "请指定项目名"
    echo "用法: $0 <命令> <项目名>"
    exit 1
fi

PROJECT_NAME=$1

case "$COMMAND" in
    "build")
        echo "正在触发 Jenkins 构建: $PROJECT_NAME"
        $JENKINS_CLI build "$PROJECT_NAME"
        ;;
    *)
        echo "错误: 不支持的命令: $COMMAND"
        echo "用法: $0 <命令> <项目名>"
        echo "命令: build"
        exit 1
        ;;
esac

exit $?