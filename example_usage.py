#!/usr/bin/env python3
"""
JSON Viewer 使用示例
展示如何在代码中使用 JSONViewer 类
"""

from json_viewer import JSONViewer
from pathlib import Path


def example_1_basic_usage():
    """示例1: 基本使用"""
    print("\n" + "="*60)
    print("示例1: 基本使用 - 扫描和展示JSON文件")
    print("="*60)

    # 创建查看器实例
    viewer = JSONViewer(root_dir="./data")

    # 扫描文件
    file_info_list = viewer.scan_json_files()
    print(f"\n找到 {len(file_info_list)} 个JSON文件")

    # 加载第一个文件
    if file_info_list:
        first_file = file_info_list[0]
        json_data = viewer.load_json(first_file["path"])

        if json_data:
            # 映射数据
            mapped_data = viewer.auto_mapping(json_data)

            # 打印映射结果
            viewer.print_mapped_data(mapped_data, first_file["name"])


def example_2_custom_mapping():
    """示例2: 只映射特定文件"""
    print("\n" + "="*60)
    print("示例2: 映射特定JSON文件")
    print("="*60)

    viewer = JSONViewer(root_dir="./data")

    # 直接加载特定文件
    target_file = "./data/sample_2/sql5_case_00309.json"

    if Path(target_file).exists():
        json_data = viewer.load_json(target_file)
        mapped_data = viewer.auto_mapping(json_data)

        # 只打印元数据
        print("\n元数据:")
        for key, value in mapped_data.get("metadata", {}).items():
            print(f"  {key}: {value}")

        # 只打印统计信息
        print("\n统计信息:")
        for key, value in mapped_data.get("statistics", {}).items():
            print(f"  {key}: {value}")


def example_3_generate_html_only():
    """示例3: 只生成HTML，不启动服务器"""
    print("\n" + "="*60)
    print("示例3: 生成HTML文件（不启动服务器）")
    print("="*60)

    viewer = JSONViewer(root_dir="./data")

    # 扫描和加载文件
    file_info_list = viewer.scan_json_files()
    mapped_data_list = []

    for info in file_info_list:
        json_data = viewer.load_json(info["path"])
        if json_data:
            mapped_data = viewer.auto_mapping(json_data)
            mapped_data_list.append((info["relative_path"], mapped_data))

    # 生成HTML
    html_content = viewer.generate_html(file_info_list, mapped_data_list)

    # 保存到自定义位置
    output_file = Path("custom_output.html")
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(html_content)

    print(f"\n✅ HTML已生成: {output_file.absolute()}")
    print("💡 可以直接在浏览器中打开此文件")


def example_4_filter_files():
    """示例4: 过滤特定文件"""
    print("\n" + "="*60)
    print("示例4: 过滤和处理特定文件")
    print("="*60)

    viewer = JSONViewer(root_dir="./data")
    file_info_list = viewer.scan_json_files()

    # 只处理sample_2目录下的文件
    filtered_files = [
        f for f in file_info_list
        if "sample_2" in f["relative_path"]
    ]

    print(f"\n在sample_2目录找到 {len(filtered_files)} 个文件:")
    for f in filtered_files:
        print(f"  - {f['name']} ({f['size_readable']})")


def example_5_statistics_analysis():
    """示例5: 统计分析"""
    print("\n" + "="*60)
    print("示例5: 跨文件统计分析")
    print("="*60)

    viewer = JSONViewer(root_dir="./data")
    file_info_list = viewer.scan_json_files()

    total_rubrics = 0
    total_weight = 0
    all_tags = {}

    # 统计所有文件
    for info in file_info_list:
        json_data = viewer.load_json(info["path"])
        if json_data:
            mapped_data = viewer.auto_mapping(json_data)

            # 累计统计
            stats = mapped_data.get("statistics", {})
            total_rubrics += stats.get("total_rubrics", 0)
            total_weight += stats.get("total_weight", 0)

            # 合并标签统计
            for tag, count in stats.get("tag_distribution", {}).items():
                all_tags[tag] = all_tags.get(tag, 0) + count

    # 输出汇总统计
    print(f"\n📊 总体统计:")
    print(f"  文件总数: {len(file_info_list)}")
    print(f"  评估标准总数: {total_rubrics}")
    print(f"  权重总和: {total_weight}")
    print(f"\n  标签分布:")
    for tag, count in sorted(all_tags.items(), key=lambda x: x[1], reverse=True):
        print(f"    - {tag}: {count}")


def main():
    """运行所有示例"""
    print("""
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║           JSON Viewer - 使用示例集合                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
    """)

    # 运行示例
    try:
        example_1_basic_usage()
        input("\n按Enter继续下一个示例...")

        example_2_custom_mapping()
        input("\n按Enter继续下一个示例...")

        example_3_generate_html_only()
        input("\n按Enter继续下一个示例...")

        example_4_filter_files()
        input("\n按Enter继续下一个示例...")

        example_5_statistics_analysis()

        print("\n" + "="*60)
        print("✅ 所有示例运行完成！")
        print("="*60)

    except KeyboardInterrupt:
        print("\n\n👋 示例已中断")


if __name__ == "__main__":
    main()
