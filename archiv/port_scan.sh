#!/bin/bash

# 定义要扫描的端口范围
START_PORT=1
END_PORT=65535

# 循环扫描每个端口
for ((port=$START_PORT; port<=$END_PORT; port++))
do
    # 使用 Test-NetConnection 命令检查端口是否开放
    PORT_STATUS=$(powershell.exe Test-NetConnection localhost -Port $port | findstr "TcpTestSucceeded")

    # 如果端口开放，输出端口号、占用信息和程序信息
    if [ -n "$PORT_STATUS" ]
    then
        echo "Port $port is open:"
        PID=$(netstat -ano | findstr :$port | awk '{print $5}' | awk -F: '{print $NF}')
        if [ -n "$PID" ]
        then
            echo "  Process ID: $PID"
            PROCESS=$(tasklist /FI "PID eq $PID" /FO CSV | tail -n +2 | head -n 1 | awk -F"," '{print $1}')
            echo "  Program: $PROCESS"
        fi
    fi
done
