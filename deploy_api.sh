#!/bin/bash

# 定义源目录和目标目录
SOURCE_DIR="../mfsapi"
TARGET_DIR="../../production/api"

# 检查源目录是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo "源目录 $SOURCE_DIR 不存在，退出部署。"
    exit 1
fi

# 创建目标目录（如果不存在）
mkdir -p "$TARGET_DIR"

# 复制项目文件到目标目录
echo "正在复制项目文件到 $TARGET_DIR ..."
rsync -av --delete --exclude="__pycache__" --exclude="docs" --exclude="*.md" --exclude="db" "$SOURCE_DIR/" "$TARGET_DIR/"
if [ $? -ne 0 ]; then
    echo "文件复制失败，退出部署。"
    exit 1
fi
echo "文件复制完成。"

# 进入目标目录
cd "$TARGET_DIR" || exit 1

# 创建并激活虚拟环境
echo "正在激活虚拟环境..."
VENV_DIR="$TARGET_DIR/venv"
source "$VENV_DIR/bin/activate"

# 重启 Flask 服务
# 假设使用 Gunicorn 运行 Flask 应用，需根据实际情况修改
GUNICORN_PID=$(pgrep -f "gunicorn.*run:app")
if [ -n "$GUNICORN_PID" ]; then
    echo "正在重启 Gunicorn 服务..."
    kill -HUP "$GUNICORN_PID"
else
    echo "Gunicorn 服务未运行，正在启动..."
    gunicorn -w 4 -b 0.0.0.0:5100 run:app --daemon
fi

# 退出虚拟环境
deactivate

echo "mfsapi 项目部署完成。"
