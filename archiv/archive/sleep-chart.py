import os
import matplotlib.pyplot as plt
import csv
import datetime
from matplotlib.dates import DateFormatter

# 初始化睡眠时间列表
sleep_time = []

def load_sleep_data_from_csv(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        reader = csv.reader(file)
        next(reader)  # 跳过标题行
        for row in reader:
            asleep_str = row[0]
            awake_str = row[1]
            asleep_time = datetime.datetime.strptime(asleep_str, "%Y/%m/%d %H:%M")
            awake_time = datetime.datetime.strptime(awake_str, "%Y/%m/%d %H:%M")
            sleep_time.append((asleep_time, awake_time))

def generate_sleep_chart():
    # 生成睡眠时间统计图
    x = []
    y = []

    prev_date = None  # 上一个日期
    for asleep_time, awake_time in sleep_time:
        if prev_date is None:
            prev_date = asleep_time.date()
        else:
            current_date = asleep_time.date()
            if (current_date - prev_date).days == 1:
                # 间隔为1天的数据不连线
                x.append(None)
                y.append(None)
            elif (current_date - prev_date).days > 1:
                # 出现新的日期，增加一个数值
                y.append(None)

            prev_date = current_date

        duration = (awake_time - asleep_time).total_seconds() / (60 * 60)  # 将睡眠时间转换为小时
        x.extend([asleep_time.hour + asleep_time.minute / 60, awake_time.hour + awake_time.minute / 60])
        y.extend([asleep_time.date(), asleep_time.date()])

    # 生成日期格式化器
    date_formatter = DateFormatter("%b %d")

    plt.plot(x, y, 'o-', color='blue')  # 绘制睡眠开始的蓝色点
    plt.plot([point[1].hour + point[1].minute / 60 for point in sleep_time], [point[1].date() for point in sleep_time], 'ro')  # 绘制睡眠结束的红点
    plt.xlabel('Time (hours)')
    plt.ylabel('Date')
    plt.title('Sleep Time Chart')
    plt.xlim(0, 24)  # 设置横坐标范围为 0-24 小时
    plt.xticks(range(0, 25))  # 设置横坐标刻度
    plt.gca().xaxis.set_major_formatter(plt.FuncFormatter(lambda val, _: '{:.0f}'.format(val)))  # 设置横坐标刻度格式化器
    plt.gca().yaxis.set_major_formatter(date_formatter)  # 设置纵坐标刻度格式化器
    plt.yticks(ha='center')  # 将刻度值居中显示
    plt.show()

# 主程序
file_path = r"G:\config and meta_data\sleep.csv"
if os.path.isfile(file_path):
    load_sleep_data_from_csv(file_path)
    generate_sleep_chart()
else:
    print("指定的文件路径不存在。")
