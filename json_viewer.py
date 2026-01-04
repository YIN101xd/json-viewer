#!/usr/bin/env python3
"""
JSON Viewer - 智能JSON查看器
一个功能强大的JSON文件查看和分析工具
"""

import json
import os
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any, Optional

class Colors:
    """终端颜色代码"""
    HEADER = '\033[95m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

class JSONViewer:
    """JSON查看器主类"""

    def __init__(self, data_dir: str = "./data"):
        self.data_dir = Path(data_dir)
        self.json_files: List[Path] = []
        self.json_data: Dict[str, Any] = {}

    def scan_json_files(self) -> int:
        """扫描目录中的所有JSON文件"""
        if not self.data_dir.exists():
            print(f"{Colors.RED}✗ 错误: 目录 {self.data_dir} 不存在{Colors.END}")
            return 0

        self.json_files = list(self.data_dir.rglob("*.json"))
        return len(self.json_files)

    def load_json_file(self, file_path: Path) -> Optional[Dict]:
        """加载单个JSON文件"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        except json.JSONDecodeError as e:
            print(f"{Colors.RED}✗ JSON解析错误 [{file_path.name}]: {e}{Colors.END}")
            return None
        except Exception as e:
            print(f"{Colors.RED}✗ 读取文件错误 [{file_path.name}]: {e}{Colors.END}")
            return None

    def load_all_files(self):
        """加载所有JSON文件"""
        for file_path in self.json_files:
            data = self.load_json_file(file_path)
            if data:
                self.json_data[str(file_path)] = data

    def flatten_dict(self, d: Any, parent_key: str = '') -> Dict[str, Any]:
        """扁平化嵌套字典"""
        items = []
        if isinstance(d, dict):
            for k, v in d.items():
                new_key = f"{parent_key}.{k}" if parent_key else k
                if isinstance(v, dict):
                    items.extend(self.flatten_dict(v, new_key).items())
                else:
                    items.append((new_key, v))
        return dict(items)

    def extract_metadata(self, data: Dict) -> Dict[str, Any]:
        """提取元数据"""
        metadata = {}
        metadata_fields = ['uid', 'case_id', 'client_id', 'type', 'category', 'domain', 'scene']

        for field in metadata_fields:
            if field in data:
                value = data[field]
                if isinstance(value, dict):
                    metadata[field] = self.flatten_dict(value)
                else:
                    metadata[field] = value

        return metadata

    def extract_content(self, data: Dict) -> Dict[str, Any]:
        """提取内容字段"""
        content = {}
        content_fields = ['prompt', 'example_answer_reference', 'system_prompt']

        for field in content_fields:
            if field in data:
                content[field] = data[field]

        return content

    def extract_rubrics(self, data: Dict) -> List[Dict]:
        """提取评估标准"""
        if 'rubrics' in data and isinstance(data['rubrics'], list):
            return data['rubrics']
        return []

    def calculate_statistics(self, rubrics: List[Dict]) -> Dict[str, Any]:
        """计算统计信息"""
        stats = {
            'total_rubrics': len(rubrics),
            'total_weight': 0,
            'label_distribution': {}
        }

        for rubric in rubrics:
            if 'weight' in rubric:
                stats['total_weight'] += rubric.get('weight', 0)

            if 'label' in rubric:
                label = rubric['label']
                stats['label_distribution'][label] = stats['label_distribution'].get(label, 0) + 1

        return stats

    def print_separator(self, char: str = "─", length: int = 80):
        """打印分隔线"""
        print(Colors.CYAN + char * length + Colors.END)

    def print_header(self, text: str):
        """打印标题"""
        self.print_separator("═")
        print(f"{Colors.BOLD}{Colors.BLUE}  {text}{Colors.END}")
        self.print_separator("═")

    def print_section(self, title: str):
        """打印章节标题"""
        print(f"\n{Colors.BOLD}{Colors.YELLOW}▶ {title}{Colors.END}")
        self.print_separator("─", 60)

    def print_metadata(self, metadata: Dict):
        """打印元数据"""
        if not metadata:
            return

        self.print_section("元数据 (Metadata)")

        for key, value in metadata.items():
            if isinstance(value, dict):
                print(f"{Colors.GREEN}{key}:{Colors.END}")
                for sub_key, sub_value in value.items():
                    print(f"  • {sub_key}: {sub_value}")
            else:
                print(f"{Colors.GREEN}{key}:{Colors.END} {value}")

    def print_content(self, content: Dict):
        """打印内容"""
        if not content:
            return

        self.print_section("内容 (Content)")

        for key, value in content.items():
            print(f"\n{Colors.GREEN}{key}:{Colors.END}")
            if isinstance(value, str):
                length = len(value)
                preview = value[:200] + "..." if length > 200 else value
                print(f"  长度: {length} 字符")
                print(f"  预览: {preview}")
            else:
                print(f"  {value}")

    def print_rubrics(self, rubrics: List[Dict]):
        """打印评估标准"""
        if not rubrics:
            return

        self.print_section(f"评估标准 (Evaluation) - 共 {len(rubrics)} 项")

        for idx, rubric in enumerate(rubrics, 1):
            print(f"\n{Colors.CYAN}[{idx}]{Colors.END} {rubric.get('label', 'N/A')}")

            if 'sub_label' in rubric:
                print(f"  二级标签: {rubric['sub_label']}")

            if 'description' in rubric:
                desc = rubric['description']
                preview = desc[:150] + "..." if len(desc) > 150 else desc
                print(f"  说明: {preview}")

            if 'weight' in rubric:
                print(f"  权重: {rubric['weight']}")

            if 'model1_judgement' in rubric:
                judgment = rubric['model1_judgement']
                score = judgment.get('score', 'N/A')
                color = Colors.GREEN if score == 1 else Colors.RED
                print(f"  Model1 评分: {color}{score}{Colors.END}")
                if 'reason' in judgment:
                    reason = judgment['reason'][:100] + "..." if len(judgment['reason']) > 100 else judgment['reason']
                    print(f"    原因: {reason}")

            if 'model2_judgement' in rubric:
                judgment = rubric['model2_judgement']
                score = judgment.get('score', 'N/A')
                color = Colors.GREEN if score == 1 else Colors.RED
                print(f"  Model2 评分: {color}{score}{Colors.END}")
                if 'reason' in judgment:
                    reason = judgment['reason'][:100] + "..." if len(judgment['reason']) > 100 else judgment['reason']
                    print(f"    原因: {reason}")

    def print_statistics(self, stats: Dict):
        """打印统计信息"""
        if not stats:
            return

        self.print_section("统计信息 (Statistics)")

        print(f"{Colors.GREEN}评估标准总数:{Colors.END} {stats['total_rubrics']}")
        print(f"{Colors.GREEN}权重总和:{Colors.END} {stats['total_weight']}")

        if stats['label_distribution']:
            print(f"\n{Colors.GREEN}标签分布:{Colors.END}")
            for label, count in sorted(stats['label_distribution'].items()):
                print(f"  • {label}: {count}")

    def print_file_info(self, file_path: Path):
        """打印文件信息"""
        stat = file_path.stat()
        size = stat.st_size
        size_str = f"{size / 1024:.2f} KB" if size > 1024 else f"{size} B"
        mtime = datetime.fromtimestamp(stat.st_mtime).strftime('%Y-%m-%d %H:%M:%S')

        print(f"{Colors.BLUE}文件:{Colors.END} {file_path.name}")
        print(f"{Colors.BLUE}路径:{Colors.END} {file_path}")
        print(f"{Colors.BLUE}大小:{Colors.END} {size_str}")
        print(f"{Colors.BLUE}修改时间:{Colors.END} {mtime}")

    def view_file(self, file_path: Path, data: Dict):
        """查看单个文件"""
        print("\n")
        self.print_header(f"📄 {file_path.name}")

        self.print_file_info(file_path)

        metadata = self.extract_metadata(data)
        self.print_metadata(metadata)

        content = self.extract_content(data)
        self.print_content(content)

        rubrics = self.extract_rubrics(data)
        self.print_rubrics(rubrics)

        stats = self.calculate_statistics(rubrics)
        self.print_statistics(stats)

        print("\n")
        self.print_separator("═")

    def print_summary(self):
        """打印总体统计"""
        total_files = len(self.json_data)
        total_size = sum(Path(p).stat().st_size for p in self.json_data.keys())
        total_rubrics = sum(
            len(self.extract_rubrics(data))
            for data in self.json_data.values()
        )

        self.print_header("📊 总体统计")
        print(f"{Colors.GREEN}JSON文件总数:{Colors.END} {total_files}")
        print(f"{Colors.GREEN}文件总大小:{Colors.END} {total_size / 1024:.2f} KB")
        print(f"{Colors.GREEN}评估标准总数:{Colors.END} {total_rubrics}")
        print()

    def interactive_menu(self):
        """交互式菜单"""
        while True:
            self.print_separator("═")
            print(f"{Colors.BOLD}📋 文件列表{Colors.END}")
            self.print_separator("─", 60)

            file_list = list(self.json_data.keys())
            for idx, file_path in enumerate(file_list, 1):
                name = Path(file_path).name
                print(f"  {Colors.CYAN}{idx}.{Colors.END} {name}")

            print(f"\n  {Colors.CYAN}0.{Colors.END} 退出")
            self.print_separator("─", 60)

            try:
                choice = input(f"\n{Colors.YELLOW}请选择文件 (输入编号): {Colors.END}").strip()

                if choice == '0':
                    print(f"\n{Colors.GREEN}👋 感谢使用 JSON Viewer!{Colors.END}\n")
                    break

                idx = int(choice) - 1
                if 0 <= idx < len(file_list):
                    file_path = Path(file_list[idx])
                    data = self.json_data[file_list[idx]]
                    self.view_file(file_path, data)

                    input(f"\n{Colors.YELLOW}按 Enter 继续...{Colors.END}")
                else:
                    print(f"{Colors.RED}✗ 无效的选择{Colors.END}")

            except ValueError:
                print(f"{Colors.RED}✗ 请输入有效的数字{Colors.END}")
            except KeyboardInterrupt:
                print(f"\n\n{Colors.GREEN}👋 感谢使用 JSON Viewer!{Colors.END}\n")
                break

    def run(self):
        """运行查看器"""
        print(f"\n{Colors.BOLD}{Colors.BLUE}🔍 扫描JSON文件...{Colors.END}")
        count = self.scan_json_files()

        if count == 0:
            print(f"{Colors.YELLOW}⚠️  未找到JSON文件{Colors.END}")
            print(f"请将JSON文件放入 {self.data_dir} 目录\n")
            return

        print(f"{Colors.GREEN}✓ 找到 {count} 个JSON文件{Colors.END}\n")

        print(f"{Colors.BOLD}{Colors.BLUE}📥 加载JSON文件...{Colors.END}")
        self.load_all_files()

        if not self.json_data:
            print(f"{Colors.RED}✗ 没有成功加载任何文件{Colors.END}\n")
            return

        print(f"{Colors.GREEN}✓ 成功加载 {len(self.json_data)} 个文件{Colors.END}\n")

        self.print_summary()

        self.interactive_menu()

def main():
    """主函数"""
    viewer = JSONViewer()
    viewer.run()

if __name__ == "__main__":
    main()
