import sys
import re

# 定义一个自定义排序函数，按照指定顺序排序
def custom_sort(match):
    order = {'I': 1, 'Q': 2, 'V': 3, 'M': 4}
    # 返回一个元组，包含匹配的前缀和排序的序号
    return (order[match[0].upper()], match)

# 检查是否提供了文件路径参数
if len(sys.argv) != 2:
    print("Usage: python script.py path_to_file")
    sys.exit(1)

# 从命令行参数获取文件路径
file_path = sys.argv[1]

# 尝试以不同编码读取文件
valid_encodings = ['utf-8', 'utf-8-sig', 'ISO-8859-1', 'windows-1252']
text = ""
for encoding in valid_encodings:
    try:
        with open(file_path, 'r', encoding=encoding) as file:
            text = file.read()
            break  # 一旦成功读取，就退出循环
    except (FileNotFoundError, UnicodeDecodeError) as e:
        print(f"Error reading file {file_path} with encoding {encoding}: {e}")
        continue

# 如果没有找到合适的编码，则报错
if not text:
    print(f"Could not decode the file {file_path} with the encodings: {valid_encodings}")
    sys.exit(1)

# 使用正则表达式匹配以V、M、I、Q开头且以点后跟数字结尾的变量
pattern = r'\b[VMIQ][a-zA-Z0-9_]*\.\d+'

# 使用re.findall查找所有匹配的字符串
matches = re.findall(pattern, text)

# 将匹配结果转换为set来去除重复项，然后转换回list
unique_matches = list(set(matches))

# 对匹配结果进行排序
sorted_unique_matches = sorted(unique_matches, key=custom_sort)

# 输出匹配到的变量
print("Found unique variables, sorted:")
for match in sorted_unique_matches:
    print(match)
