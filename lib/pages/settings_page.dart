import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoAnalyzeFiles = true;
  bool _enableNotifications = true;
  bool _autoCheckUpdates = false;
  bool _enableDarkMode = false;
  String _downloadPath = 'C:\\Users\\Downloads\\Minecraft';
  String _defaultMinecraftPath = 'C:\\Users\\AppData\\Roaming\\.minecraft';
  int _maxConcurrentDownloads = 3;
  String _language = '中文';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildGeneralSection(),
          const SizedBox(height: 16),
          _buildDownloadSection(),
          const SizedBox(height: 16),
          _buildFileManagementSection(),
          const SizedBox(height: 16),
          _buildAppearanceSection(),
          const SizedBox(height: 16),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('常规设置', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('自动检查更新'),
              subtitle: const Text('启动时检查应用更新'),
              value: _autoCheckUpdates,
              onChanged: (value) {
                setState(() {
                  _autoCheckUpdates = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('启用通知'),
              subtitle: const Text('显示下载完成等通知'),
              value: _enableNotifications,
              onChanged: (value) {
                setState(() {
                  _enableNotifications = value;
                });
              },
            ),
            ListTile(
              title: const Text('语言'),
              subtitle: Text(_language),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showLanguageDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('下载设置', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('下载目录'),
              subtitle: Text(_downloadPath),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copyToClipboard(_downloadPath),
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: _selectDownloadPath,
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text('最大并发下载数'),
              subtitle: Text('当前：$_maxConcurrentDownloads'),
              trailing: SizedBox(
                width: 200,
                child: Slider(
                  value: _maxConcurrentDownloads.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  label: _maxConcurrentDownloads.toString(),
                  onChanged: (value) {
                    setState(() {
                      _maxConcurrentDownloads = value.round();
                    });
                  },
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('清除下载缓存'),
              subtitle: const Text('清除已完成的下载记录'),
              trailing: ElevatedButton(
                onPressed: _clearDownloadCache,
                child: const Text('清除'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileManagementSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('文件管理', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('自动分析文件'),
              subtitle: const Text('拖入文件时自动进行分析'),
              value: _autoAnalyzeFiles,
              onChanged: (value) {
                setState(() {
                  _autoAnalyzeFiles = value;
                });
              },
            ),
            ListTile(
              title: const Text('Minecraft目录'),
              subtitle: Text(_defaultMinecraftPath),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: () => _copyToClipboard(_defaultMinecraftPath),
                  ),
                  IconButton(
                    icon: const Icon(Icons.folder_open),
                    onPressed: _selectMinecraftPath,
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('支持的文件格式'),
              subtitle: const Text('查看支持的文件类型'),
              trailing: const Icon(Icons.info_outline),
              onTap: _showSupportedFormatsDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('外观设置', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('深色模式'),
              subtitle: const Text('使用深色主题'),
              value: _enableDarkMode,
              onChanged: (value) {
                setState(() {
                  _enableDarkMode = value;
                });
                _showMessage('重启应用后生效');
              },
            ),
            ListTile(
              title: const Text('主题颜色'),
              subtitle: const Text('绿色（默认）'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildColorCircle(Colors.green),
                  const SizedBox(width: 8),
                  _buildColorCircle(Colors.blue),
                  const SizedBox(width: 8),
                  _buildColorCircle(Colors.purple),
                  const SizedBox(width: 8),
                  _buildColorCircle(Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('关于', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('版本'),
              subtitle: const Text('MC助手 v1.0.0'),
              trailing: const Icon(Icons.info),
            ),
            ListTile(
              title: const Text('检查更新'),
              subtitle: const Text('查看是否有新版本'),
              trailing: const Icon(Icons.system_update),
              onTap: _checkForUpdates,
            ),
            ListTile(
              title: const Text('使用帮助'),
              subtitle: const Text('查看使用说明'),
              trailing: const Icon(Icons.help),
              onTap: _showHelpDialog,
            ),
            ListTile(
              title: const Text('意见反馈'),
              subtitle: const Text('提交问题或建议'),
              trailing: const Icon(Icons.feedback),
              onTap: _openFeedback,
            ),
            const Divider(),
            ListTile(
              title: const Text('重置设置'),
              subtitle: const Text('恢复所有设置为默认值'),
              trailing: const Icon(Icons.restore, color: Colors.red),
              onTap: _showResetDialog,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return GestureDetector(
      onTap: () => _showMessage('主题颜色已更改为${_getColorName(color)}'),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  String _getColorName(Color color) {
    if (color == Colors.green) return '绿色';
    if (color == Colors.blue) return '蓝色';
    if (color == Colors.purple) return '紫色';
    if (color == Colors.orange) return '橙色';
    return '未知';
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择语言'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('中文'),
              value: '中文',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                Navigator.pop(context);
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                Navigator.pop(context);
                _showMessage('重启应用后生效');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void _selectDownloadPath() {
    _showMessage('在实际应用中，这里会打开文件夹选择对话框');
  }

  void _selectMinecraftPath() {
    _showMessage('在实际应用中，这里会打开文件夹选择对话框');
  }

  void _clearDownloadCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除下载缓存'),
        content: const Text('确定要清除所有下载记录吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showMessage('下载缓存已清除');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showSupportedFormatsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('支持的文件格式'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('压缩文件：', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• .zip, .rar, .7z'),
            SizedBox(height: 8),
            Text('模组文件：', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• .jar'),
            SizedBox(height: 8),
            Text('配置文件：', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• .json, .toml, .cfg'),
            SizedBox(height: 8),
            Text('其他：', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• .mcmeta, .txt'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('检查更新'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在检查更新...'),
          ],
        ),
      ),
    );

    // 模拟检查更新
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('检查完成'),
          content: const Text('当前已是最新版本！'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('确定'),
            ),
          ],
        ),
      );
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('使用帮助'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('1. 文件识别', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• 将压缩文件拖拽到下载管理页面即可自动识别类型'),
              SizedBox(height: 8),
              Text('2. 下载管理', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• 支持暂停、继续、删除下载任务'),
              SizedBox(height: 8),
              Text('3. 工具使用', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• 种子生成器可以将文字转换为游戏种子'),
              Text('• 坐标转换器可以转换主世界和下界坐标'),
              SizedBox(height: 8),
              Text('4. 其他功能', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('• 常用网站页面收录了MC相关的重要网站'),
              Text('• Java下载页面提供了各版本Java的下载链接'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _openFeedback() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('意见反馈'),
        content: const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '请描述您遇到的问题或建议...',
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
              Navigator.pop(context);
              _showMessage('感谢您的反馈！');
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置设置'),
        content: const Text('确定要重置所有设置为默认值吗？此操作不可撤销。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _autoAnalyzeFiles = true;
                _enableNotifications = true;
                _autoCheckUpdates = false;
                _enableDarkMode = false;
                _downloadPath = 'C:\\Users\\Downloads\\Minecraft';
                _defaultMinecraftPath =
                    'C:\\Users\\AppData\\Roaming\\.minecraft';
                _maxConcurrentDownloads = 3;
                _language = '中文';
              });
              _showMessage('设置已重置为默认值');
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    _showMessage('路径已复制到剪贴板');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
