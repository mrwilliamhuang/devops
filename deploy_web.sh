#!/bin/bash

# 定义项目目录和目标目录
PROJECT_DIR="../mfsweb"
TARGET_DIR="$HOME/production/web"

# 进入项目目录
cd "$PROJECT_DIR" || {
    echo "无法进入项目目录 $PROJECT_DIR，退出部署。"
    exit 1
}

# 执行 Angular 生产环境构建
echo "正在执行 Angular 生产环境构建..."
ng build -c production
BUILD_STATUS=$?
if [ $BUILD_STATUS -ne 0 ]; then
    echo "Angular 构建失败，退出部署。"
    exit 1
fi
echo "Angular 构建完成。"

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 复制构建后的文件到目标目录
echo "正在复制构建后的文件到 $TARGET_DIR ..."
rsync -av --delete "$PROJECT_DIR/dist/studentscore/browser/" "$TARGET_DIR/"
COPY_STATUS=$?
if [ $COPY_STATUS -ne 0 ]; then
    echo "文件复制失败，退出部署。"
    exit 1
fi
echo "文件复制完成。"

echo "mfsweb 项目部署完成。"
