import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ModManagerPage extends StatefulWidget {
  const ModManagerPage({super.key});

  @override
  State<ModManagerPage> createState() => _ModManagerPageState();
}

class _ModManagerPageState extends State<ModManagerPage> {
  final TextEditingController _pathController = TextEditingController();
  String _fileType = '';
  List<String> _tips = [];
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('模组识别与管理'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: EdgeInsets.all(isWideScreen ? 24.0 : 16.0),
        child: isWideScreen
            ? _buildWideScreenLayout(context)
            : _buildNarrowScreenLayout(context),
      ),
    );
  }

  Widget _buildWideScreenLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧 - 文件分析区域
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(context, true),
              const SizedBox(height: 16),
              _buildAnalysisSection(context, true),
            ],
          ),
        ),
        const SizedBox(width: 24),
        // 右侧 - 结果显示区域
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading) _buildLoadingWidget(),
              if (_fileType.isNotEmpty && !_isLoading)
                _buildResultCard(context),
              if (_tips.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildTipsSection(context, true),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowScreenLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderCard(context, false),
        const SizedBox(height: 16),
        _buildAnalysisSection(context, false),
        const SizedBox(height: 16),
        if (_isLoading) _buildLoadingWidget(),
        if (_fileType.isNotEmpty && !_isLoading) ...[
          _buildResultCard(context),
          const SizedBox(height: 8),
        ],
        if (_tips.isNotEmpty)
          Expanded(child: _buildTipsSection(context, false)),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context, bool isWideScreen) {
    return Card(
      elevation: isWideScreen ? 4 : 2,
      child: Padding(
        padding: EdgeInsets.all(isWideScreen ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '文件识别器',
              style: isWideScreen
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '输入文件路径，自动识别是整合包、光影包还是材质包',
              style: isWideScreen
                  ? Theme.of(context).textTheme.bodyLarge
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisSection(BuildContext context, bool isWideScreen) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isWideScreen ? 20.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _pathController,
              decoration: const InputDecoration(
                labelText: '文件路径',
                hintText: '例如：C:\\path\\to\\modpack.zip',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.folder),
              ),
            ),
            SizedBox(height: isWideScreen ? 16 : 12),
            isWideScreen
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _analyzeFile,
                          icon: const Icon(Icons.search),
                          label: const Text('分析文件'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _clearSelection,
                          icon: const Icon(Icons.clear),
                          label: const Text('清除'),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _analyzeFile,
                          icon: const Icon(Icons.search),
                          label: const Text('分析文件'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _clearSelection,
                          icon: const Icon(Icons.clear),
                          label: const Text('清除'),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('正在分析文件...'),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _getFileTypeIcon(),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _pathController.text.split('/').last.split('\\').last,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        _fileType,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context, bool isWideScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('识别建议', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        isWideScreen
            ? Expanded(
                child: Card(
                  child: ListView.builder(
                    itemCount: _tips.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.lightbulb,
                          color: Colors.amber,
                        ),
                        title: Text(_tips[index]),
                        dense: true,
                      );
                    },
                  ),
                ),
              )
            : Card(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _tips.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.lightbulb, color: Colors.amber),
                      title: Text(_tips[index]),
                      dense: true,
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _getFileTypeIcon() {
    switch (_fileType) {
      case '整合包 (Modpack)':
        return const Icon(Icons.inventory_2, color: Colors.blue, size: 32);
      case '光影包 (Shader Pack)':
        return const Icon(Icons.wb_sunny, color: Colors.orange, size: 32);
      case '材质包 (Resource Pack)':
        return const Icon(Icons.texture, color: Colors.green, size: 32);
      case '数据包 (Data Pack)':
        return const Icon(Icons.data_object, color: Colors.purple, size: 32);
      case '模组文件 (Mod)':
        return const Icon(Icons.extension, color: Colors.red, size: 32);
      default:
        return const Icon(Icons.help_outline, color: Colors.grey, size: 32);
    }
  }

  Future<void> _analyzeFile() async {
    final path = _pathController.text.trim();
    if (path.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final file = File(path);
      if (!await file.exists()) {
        _showError('文件不存在');
        return;
      }

      final fileName = file.path.toLowerCase();
      final fileType = _identifyFileType(fileName);
      final tips = _generateTips(fileName, fileType);

      setState(() {
        _fileType = fileType;
        _tips = tips;
      });
    } catch (e) {
      _showError('分析文件时出错: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _identifyFileType(String fileName) {
    if (fileName.contains('modpack') || fileName.contains('manifest')) {
      return '整合包 (Modpack)';
    } else if (fileName.contains('shader') || fileName.contains('light')) {
      return '光影包 (Shader Pack)';
    } else if (fileName.contains('resource') || fileName.contains('texture')) {
      return '材质包 (Resource Pack)';
    } else if (fileName.contains('data')) {
      return '数据包 (Data Pack)';
    } else if (fileName.endsWith('.jar') && !fileName.contains('minecraft')) {
      return '模组文件 (Mod)';
    } else {
      return '未知文件类型';
    }
  }

  List<String> _generateTips(String fileName, String fileType) {
    List<String> tips = [];

    switch (fileType) {
      case '整合包 (Modpack)':
        tips.addAll([
          '整合包通常需要对应的启动器来安装',
          '检查是否包含manifest.json文件',
          '确认Minecraft版本兼容性',
        ]);
        break;
      case '光影包 (Shader Pack)':
        tips.addAll([
          '光影包需要OptiFine或Iris模组支持',
          '注意显卡性能要求',
          '放入.minecraft/shaderpacks文件夹',
        ]);
        break;
      case '材质包 (Resource Pack)':
        tips.addAll(['材质包可直接在游戏中安装', '检查分辨率是否适合你的设备', '注意版本兼容性']);
        break;
      case '模组文件 (Mod)':
        tips.addAll([
          '确认是Forge还是Fabric模组',
          '检查Minecraft版本兼容性',
          '放入.minecraft/mods文件夹',
        ]);
        break;
      default:
        tips.add('无法确定文件类型，请检查文件名或扩展名');
    }

    return tips;
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _clearSelection() {
    setState(() {
      _pathController.clear();
      _fileType = '';
      _tips.clear();
    });
  }

  @override
  void dispose() {
    _pathController.dispose();
    super.dispose();
  }
}
