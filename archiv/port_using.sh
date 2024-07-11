#!/bin/bash

# 定义要监控的端口号
PORT=8080

# 循环检查端口是否被占用
while true
do
    # 使用 netstat 命令获取当前端口使用情况
    PORT_STATUS=$(netstat -ano | findstr :$PORT)

    # 如果端口被占用，输出占用信息
    if [ -n "$PORT_STATUS" ]
    then
        echo "Port $PORT is in use:"
        echo "$PORT_STATUS"
    fi

    # 等待 5 秒后再次检查
    sleep 5
done
