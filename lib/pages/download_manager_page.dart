import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'file_analysis_detail_page.dart';

class DownloadManagerPage extends StatefulWidget {
  const DownloadManagerPage({super.key});

  @override
  State<DownloadManagerPage> createState() => _DownloadManagerPageState();
}

class _DownloadManagerPageState extends State<DownloadManagerPage> {
  final List<DownloadItem> _downloads = [];
  bool _isDragOver = false;

  @override
  void initState() {
    super.initState();
    _initializeSampleDownloads();
  }

  void _initializeSampleDownloads() {
    _downloads.addAll([
      DownloadItem(
        name: 'All the Mods 9.zip',
        type: '整合包',
        size: '156.7 MB',
        progress: 1.0,
        status: DownloadStatus.completed,
        url: 'https://example.com/atm9.zip',
      ),
      DownloadItem(
        name: 'Complementary Shaders.zip',
        type: '光影包',
        size: '23.4 MB',
        progress: 0.65,
        status: DownloadStatus.downloading,
        url: 'https://example.com/complementary.zip',
      ),
      DownloadItem(
        name: 'Faithful 32x.zip',
        type: '材质包',
        size: '45.2 MB',
        progress: 0.0,
        status: DownloadStatus.paused,
        url: 'https://example.com/faithful.zip',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('下载管理'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddDownloadDialog,
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearCompletedDownloads,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDropZone(),
          const SizedBox(height: 16),
          Expanded(child: _buildDownloadList()),
        ],
      ),
    );
  }

  Widget _buildDropZone() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: DragTarget<List<File>>(
        onWillAccept: (data) {
          setState(() {
            _isDragOver = true;
          });
          return data != null;
        },
        onLeave: (data) {
          setState(() {
            _isDragOver = false;
          });
        },
        onAccept: (files) {
          setState(() {
            _isDragOver = false;
          });
          _handleDroppedFiles(files);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: _isDragOver
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: _isDragOver
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.surface,
            ),
            child: InkWell(
              onTap: _pickFiles,
              borderRadius: BorderRadius.circular(12),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isDragOver ? Icons.file_download : Icons.cloud_upload,
                      size: 48,
                      color: _isDragOver
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isDragOver ? '释放文件以识别' : '拖放文件到此处或点击选择文件',
                      style: TextStyle(
                        fontSize: 16,
                        color: _isDragOver
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '支持 .zip, .jar, .rar 等压缩文件',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDownloadList() {
    if (_downloads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_for_offline,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '暂无下载任务',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              '点击上方 + 按钮或拖放文件开始',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _downloads.length,
      itemBuilder: (context, index) {
        final download = _downloads[index];
        return _buildDownloadCard(download, index);
      },
    );
  }

  Widget _buildDownloadCard(DownloadItem download, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getTypeIcon(download.type),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        download.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${download.type} • ${download.size}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(download.status),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleMenuAction(value, index),
                  itemBuilder: (context) => [
                    if (download.status == DownloadStatus.downloading)
                      const PopupMenuItem(
                        value: 'pause',
                        child: Row(
                          children: [
                            Icon(Icons.pause),
                            SizedBox(width: 8),
                            Text('暂停'),
                          ],
                        ),
                      ),
                    if (download.status == DownloadStatus.paused)
                      const PopupMenuItem(
                        value: 'resume',
                        child: Row(
                          children: [
                            Icon(Icons.play_arrow),
                            SizedBox(width: 8),
                            Text('继续'),
                          ],
                        ),
                      ),
                    if (download.status == DownloadStatus.completed)
                      const PopupMenuItem(
                        value: 'analyze',
                        child: Row(
                          children: [
                            Icon(Icons.analytics),
                            SizedBox(width: 8),
                            Text('分析文件'),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'copy_url',
                      child: Row(
                        children: [
                          Icon(Icons.copy),
                          SizedBox(width: 8),
                          Text('复制链接'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('移除', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (download.status == DownloadStatus.downloading ||
                download.status == DownloadStatus.paused) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: download.progress,
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(download.progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getTypeIcon(String type) {
    IconData icon;
    Color color;

    switch (type) {
      case '整合包':
        icon = Icons.inventory_2;
        color = Colors.blue;
        break;
      case '光影包':
        icon = Icons.wb_sunny;
        color = Colors.orange;
        break;
      case '材质包':
        icon = Icons.texture;
        color = Colors.green;
        break;
      case '模组':
        icon = Icons.extension;
        color = Colors.red;
        break;
      default:
        icon = Icons.archive;
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildStatusChip(DownloadStatus status) {
    String text;
    Color color;
    IconData icon;

    switch (status) {
      case DownloadStatus.downloading:
        text = '下载中';
        color = Colors.blue;
        icon = Icons.download;
        break;
      case DownloadStatus.completed:
        text = '已完成';
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case DownloadStatus.paused:
        text = '已暂停';
        color = Colors.orange;
        icon = Icons.pause_circle;
        break;
      case DownloadStatus.failed:
        text = '失败';
        color = Colors.red;
        icon = Icons.error;
        break;
    }

    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }

  void _handleDroppedFiles(List<File> files) {
    for (final file in files) {
      _analyzeAndAddFile(file);
    }
  }

  void _pickFiles() async {
    // 在实际应用中，这里会使用 file_picker 包
    _showMessage('请使用拖放功能或在实际应用中集成文件选择器');
  }

  void _analyzeAndAddFile(File file) {
    final fileName = file.path.split('/').last.split('\\').last;
    final fileType = _identifyFileType(fileName.toLowerCase());
    final fileSize = _getFileSizeString(file.lengthSync());

    final downloadItem = DownloadItem(
      name: fileName,
      type: fileType,
      size: fileSize,
      progress: 1.0,
      status: DownloadStatus.completed,
      url: file.path,
    );

    setState(() {
      _downloads.insert(0, downloadItem);
    });

    _showMessage('文件已识别为：$fileType');

    // 自动分析文件
    _analyzeFile(downloadItem, 0);
  }

  String _identifyFileType(String fileName) {
    if (fileName.contains('modpack') || fileName.contains('manifest')) {
      return '整合包';
    } else if (fileName.contains('shader') || fileName.contains('光影')) {
      return '光影包';
    } else if (fileName.contains('resource') ||
        fileName.contains('texture') ||
        fileName.contains('材质')) {
      return '材质包';
    } else if (fileName.endsWith('.jar') && !fileName.contains('minecraft')) {
      return '模组';
    } else {
      return '未知';
    }
  }

  String _getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _handleMenuAction(String action, int index) async {
    final download = _downloads[index];

    switch (action) {
      case 'pause':
        setState(() {
          _downloads[index] = download.copyWith(status: DownloadStatus.paused);
        });
        break;
      case 'resume':
        setState(() {
          _downloads[index] = download.copyWith(
            status: DownloadStatus.downloading,
          );
        });
        break;
      case 'analyze':
        _analyzeFile(download, index);
        break;
      case 'copy_url':
        await Clipboard.setData(ClipboardData(text: download.url));
        _showMessage('链接已复制到剪贴板');
        break;
      case 'remove':
        setState(() {
          _downloads.removeAt(index);
        });
        break;
    }
  }

  void _analyzeFile(DownloadItem download, int index) {
    // 模拟文件内容分析
    final List<String> fileContents = _generateMockFileContents(download.type);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FileAnalysisDetailPage(
          fileName: download.name,
          fileType: download.type,
          fileContents: fileContents,
        ),
      ),
    );
  }

  List<String> _generateMockFileContents(String type) {
    switch (type) {
      case '整合包':
        return [
          'manifest.json',
          'mods/',
          'mods/jei-1.19.2.jar',
          'mods/applied-energistics-2.jar',
          'config/',
          'config/jei.cfg',
          'resourcepacks/',
          'saves/',
        ];
      case '光影包':
        return [
          'shaders/',
          'shaders/gbuffers_basic.fsh',
          'shaders/gbuffers_basic.vsh',
          'shaders/composite.fsh',
          'shaders/final.fsh',
          'pack.mcmeta',
        ];
      case '材质包':
        return [
          'pack.mcmeta',
          'assets/',
          'assets/minecraft/',
          'assets/minecraft/textures/',
          'assets/minecraft/textures/block/',
          'assets/minecraft/textures/item/',
          'assets/minecraft/models/',
        ];
      default:
        return ['未知文件结构'];
    }
  }

  void _showAddDownloadDialog() {
    final urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('添加下载'),
        content: TextField(
          controller: urlController,
          decoration: const InputDecoration(
            labelText: '下载链接',
            hintText: '输入文件下载URL',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                _addDownloadFromUrl(urlController.text);
                Navigator.pop(context);
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _addDownloadFromUrl(String url) {
    final fileName = url.split('/').last;
    final fileType = _identifyFileType(fileName.toLowerCase());

    final downloadItem = DownloadItem(
      name: fileName,
      type: fileType,
      size: '未知',
      progress: 0.0,
      status: DownloadStatus.downloading,
      url: url,
    );

    setState(() {
      _downloads.insert(0, downloadItem);
    });

    // 模拟下载进度
    _simulateDownload(0);
  }

  void _simulateDownload(int index) {
    if (index >= _downloads.length) return;

    final timer = Stream.periodic(
      const Duration(milliseconds: 100),
      (count) => count,
    );
    timer
        .take(100)
        .listen(
          (count) {
            if (index < _downloads.length &&
                _downloads[index].status == DownloadStatus.downloading) {
              setState(() {
                _downloads[index] = _downloads[index].copyWith(
                  progress: (count + 1) / 100,
                );
              });
            }
          },
          onDone: () {
            if (index < _downloads.length) {
              setState(() {
                _downloads[index] = _downloads[index].copyWith(
                  status: DownloadStatus.completed,
                  size: '${(20 + index * 15).toStringAsFixed(1)} MB',
                );
              });
            }
          },
        );
  }

  void _clearCompletedDownloads() {
    setState(() {
      _downloads.removeWhere(
        (download) => download.status == DownloadStatus.completed,
      );
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

enum DownloadStatus { downloading, completed, paused, failed }

class DownloadItem {
  final String name;
  final String type;
  final String size;
  final double progress;
  final DownloadStatus status;
  final String url;

  DownloadItem({
    required this.name,
    required this.type,
    required this.size,
    required this.progress,
    required this.status,
    required this.url,
  });

  DownloadItem copyWith({
    String? name,
    String? type,
    String? size,
    double? progress,
    DownloadStatus? status,
    String? url,
  }) {
    return DownloadItem(
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      url: url ?? this.url,
    );
  }
}
