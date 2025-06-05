import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FileAnalysisDetailPage extends StatelessWidget {
  final String fileName;
  final String fileType;
  final List<String> fileContents;

  const FileAnalysisDetailPage({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.fileContents,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文件详情分析'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareAnalysisReport(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _getFileTypeIcon(fileType, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fileName,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                fileType,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFileStats(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '文件内容 (${fileContents.length}项)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _showSearchDialog(context),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showFilterDialog(context),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: ListView.builder(
                  itemCount: fileContents.length,
                  itemBuilder: (context, index) {
                    final item = fileContents[index];
                    return ListTile(
                      dense: true,
                      leading: _getFileIcon(item),
                      title: Text(item, style: const TextStyle(fontSize: 13)),
                      subtitle: _getFileDescription(item),
                      trailing: _getFileSize(item),
                      onTap: () => _showFileDetails(context, item),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileStats() {
    final stats = _analyzeFileStats();
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            '文件夹',
            stats['folders'].toString(),
            Icons.folder,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            '配置文件',
            stats['configs'].toString(),
            Icons.settings,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            '资源文件',
            stats['resources'].toString(),
            Icons.image,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            '其他',
            stats['others'].toString(),
            Icons.description,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Map<String, int> _analyzeFileStats() {
    int folders = 0;
    int configs = 0;
    int resources = 0;
    int others = 0;

    for (final item in fileContents) {
      if (item.endsWith('/')) {
        folders++;
      } else if (item.endsWith('.cfg') ||
          item.endsWith('.toml') ||
          item.endsWith('.json') ||
          item.endsWith('.properties')) {
        configs++;
      } else if (item.endsWith('.png') ||
          item.endsWith('.jpg') ||
          item.endsWith('.ogg') ||
          item.endsWith('.mcmeta')) {
        resources++;
      } else {
        others++;
      }
    }

    return {
      'folders': folders,
      'configs': configs,
      'resources': resources,
      'others': others,
    };
  }

  Widget _getFileTypeIcon(String fileType, {double size = 24}) {
    switch (fileType) {
      case '整合包 (Modpack)':
        return Icon(Icons.inventory_2, color: Colors.blue, size: size);
      case '光影包 (Shader Pack)':
        return Icon(Icons.wb_sunny, color: Colors.orange, size: size);
      case '材质包 (Resource Pack)':
        return Icon(Icons.texture, color: Colors.green, size: size);
      case '数据包 (Data Pack)':
        return Icon(Icons.data_object, color: Colors.purple, size: size);
      case '模组文件 (Mod)':
      case '可能是模组文件':
        return Icon(Icons.extension, color: Colors.red, size: size);
      default:
        return Icon(Icons.help_outline, color: Colors.grey, size: size);
    }
  }

  Widget _getFileIcon(String fileName) {
    if (fileName.endsWith('/')) {
      return const Icon(Icons.folder, color: Colors.amber, size: 20);
    } else if (fileName.endsWith('.json')) {
      return const Icon(Icons.code, color: Colors.blue, size: 20);
    } else if (fileName.endsWith('.jar')) {
      return const Icon(Icons.archive, color: Colors.red, size: 20);
    } else if (fileName.endsWith('.cfg') || fileName.endsWith('.toml')) {
      return const Icon(Icons.settings, color: Colors.grey, size: 20);
    } else if (fileName.endsWith('.png') || fileName.endsWith('.jpg')) {
      return const Icon(Icons.image, color: Colors.green, size: 20);
    } else if (fileName.endsWith('.class')) {
      return const Icon(Icons.code, color: Colors.purple, size: 20);
    } else if (fileName.endsWith('.fsh') || fileName.endsWith('.vsh')) {
      return const Icon(Icons.brush, color: Colors.orange, size: 20);
    } else {
      return const Icon(Icons.insert_drive_file, color: Colors.grey, size: 20);
    }
  }

  Widget? _getFileDescription(String fileName) {
    if (fileName == 'manifest.json') {
      return const Text('整合包清单文件', style: TextStyle(fontSize: 11));
    } else if (fileName == 'pack.mcmeta') {
      return const Text('包元数据文件', style: TextStyle(fontSize: 11));
    } else if (fileName == 'mods.toml') {
      return const Text('模组配置文件', style: TextStyle(fontSize: 11));
    } else if (fileName.startsWith('config/')) {
      return const Text('配置文件', style: TextStyle(fontSize: 11));
    } else if (fileName.startsWith('assets/')) {
      return const Text('资源文件', style: TextStyle(fontSize: 11));
    }
    return null;
  }

  Widget? _getFileSize(String fileName) {
    // 模拟文件大小
    if (fileName.endsWith('/')) return null;

    final random = fileName.hashCode % 1000;
    if (fileName.endsWith('.jar')) {
      return Text(
        '${(random * 5 + 100)}KB',
        style: const TextStyle(fontSize: 11),
      );
    } else if (fileName.endsWith('.png')) {
      return Text(
        '${(random % 50 + 5)}KB',
        style: const TextStyle(fontSize: 11),
      );
    } else {
      return Text(
        '${(random % 20 + 1)}KB',
        style: const TextStyle(fontSize: 11),
      );
    }
  }

  void _showFileDetails(BuildContext context, String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('文件详情'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('文件名: $fileName'),
            const SizedBox(height: 8),
            Text('类型: ${_getFileTypeByExtension(fileName)}'),
            const SizedBox(height: 8),
            if (fileName.endsWith('.jar')) const Text('这是一个Java档案文件，可能包含模组代码'),
            if (fileName.endsWith('.json')) const Text('这是一个JSON配置文件'),
            if (fileName.endsWith('.png')) const Text('这是一个PNG图像文件'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  String _getFileTypeByExtension(String fileName) {
    if (fileName.endsWith('/')) return '文件夹';
    if (fileName.endsWith('.jar')) return 'Java档案';
    if (fileName.endsWith('.json')) return 'JSON文件';
    if (fileName.endsWith('.png')) return 'PNG图像';
    if (fileName.endsWith('.cfg')) return '配置文件';
    if (fileName.endsWith('.toml')) return 'TOML配置';
    if (fileName.endsWith('.class')) return 'Java类文件';
    return '未知文件';
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('搜索文件'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: '输入文件名关键词...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('搜索'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('过滤文件'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: const Text('显示文件夹'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('显示配置文件'),
              value: true,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              title: const Text('显示图像文件'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('应用'),
          ),
        ],
      ),
    );
  }

  void _shareAnalysisReport(BuildContext context) async {
    final report =
        '''
文件分析报告
==============
文件名: $fileName
类型: $fileType
文件数量: ${fileContents.length}

文件列表:
${fileContents.take(20).join('\n')}
${fileContents.length > 20 ? '\n... 还有 ${fileContents.length - 20} 个文件' : ''}
    ''';

    await Clipboard.setData(ClipboardData(text: report));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('分析报告已复制到剪贴板')));
  }
}
