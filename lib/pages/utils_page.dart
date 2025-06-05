import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UtilsPage extends StatefulWidget {
  const UtilsPage({super.key});

  @override
  State<UtilsPage> createState() => _UtilsPageState();
}

class _UtilsPageState extends State<UtilsPage> {
  final TextEditingController _seedController = TextEditingController();
  final TextEditingController _coordController = TextEditingController();
  String _seedResult = '';
  String _coordResult = '';
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('实用工具'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: EdgeInsets.all(isWideScreen ? 24.0 : 16.0),
        child: ListView(
          children: [
            Card(
              elevation: isWideScreen ? 4 : 2,
              child: Padding(
                padding: EdgeInsets.all(isWideScreen ? 24.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MC实用工具集',
                      style: isWideScreen
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '包含种子查询、坐标转换等实用功能',
                      style: isWideScreen
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 种子查询工具
            Card(
              child: Padding(
                padding: EdgeInsets.all(isWideScreen ? 20.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.eco, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          '种子生成器',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _seedController,
                      decoration: const InputDecoration(
                        labelText: '输入文字生成种子',
                        hintText: '例如：我的世界',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    isWideScreen
                        ? Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _generateSeed,
                                  child: const Text('生成种子'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _generateRandomSeed,
                                  child: const Text('随机种子'),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _generateSeed,
                                  child: const Text('生成种子'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _generateRandomSeed,
                                  child: const Text('随机种子'),
                                ),
                              ),
                            ],
                          ),
                    if (_seedResult.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '生成的种子: $_seedResult',
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () => _copySeed(_seedResult),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 坐标转换工具
            Card(
              child: Padding(
                padding: EdgeInsets.all(isWideScreen ? 20.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.place, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          '坐标转换器',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _coordController,
                      decoration: const InputDecoration(
                        labelText: '主世界坐标 (X,Z)',
                        hintText: '例如：100,200',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _convertCoordinates,
                        child: const Text('转换到下界坐标'),
                      ),
                    ),
                    if (_coordResult.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '下界对应坐标:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _coordResult,
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy),
                                  onPressed: () => _copyCoord(_coordResult),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 快速命令生成
            Card(
              child: Padding(
                padding: EdgeInsets.all(isWideScreen ? 20.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.terminal, color: Colors.purple),
                        const SizedBox(width: 8),
                        Text(
                          '常用命令',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildCommandButton('/time set day', '设置白天'),
                    _buildCommandButton('/weather clear', '清除天气'),
                    _buildCommandButton('/gamemode creative', '创造模式'),
                    _buildCommandButton('/gamemode survival', '生存模式'),
                    _buildCommandButton(
                      '/gamerule keepInventory true',
                      '死亡不掉落',
                    ),
                    _buildCommandButton(
                      '/locate structure minecraft:village',
                      '查找村庄',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 版本信息
            Card(
              child: Padding(
                padding: EdgeInsets.all(isWideScreen ? 20.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          '版本信息',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      title: const Text('当前最新版本'),
                      subtitle: const Text('Minecraft 1.20.4'),
                      trailing: const Icon(Icons.new_releases),
                      dense: !isWideScreen,
                    ),
                    ListTile(
                      title: const Text('热门模组版本'),
                      subtitle: const Text('1.19.2, 1.18.2, 1.16.5'),
                      trailing: const Icon(Icons.extension),
                      dense: !isWideScreen,
                    ),
                    ListTile(
                      title: const Text('推荐Java版本'),
                      subtitle: const Text('Java 17 LTS'),
                      trailing: const Icon(Icons.coffee),
                      dense: !isWideScreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandButton(String command, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _copyCommand(command),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      description,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      command,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.copy, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _generateSeed() {
    final input = _seedController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入文字来生成种子')));
      return;
    }

    // 改进的字符串哈希转换为种子
    int hash = input.hashCode;
    // 确保为正数且在合理范围内
    hash = hash.abs() % 2147483647;

    setState(() {
      _seedResult = hash.toString();
    });
  }

  void _generateRandomSeed() {
    final random = DateTime.now().millisecondsSinceEpoch % 2147483647;
    setState(() {
      _seedResult = random.toString();
    });
  }

  void _convertCoordinates() {
    final input = _coordController.text;
    if (input.isEmpty) return;

    try {
      final coords = input.split(',');
      if (coords.length != 2) return;

      final x = int.parse(coords[0].trim());
      final z = int.parse(coords[1].trim());

      final netherX = (x / 8).round();
      final netherZ = (z / 8).round();

      setState(() {
        _coordResult = '$netherX, $netherZ';
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('坐标格式错误，请使用 X,Z 格式')));
    }
  }

  void _copySeed(String seed) async {
    await Clipboard.setData(ClipboardData(text: seed));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('种子已复制到剪贴板')));
    }
  }

  void _copyCoord(String coord) async {
    await Clipboard.setData(ClipboardData(text: coord));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('坐标已复制到剪贴板')));
    }
  }

  void _copyCommand(String command) async {
    await Clipboard.setData(ClipboardData(text: command));
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('命令已复制: $command')));
    }
  }

  @override
  void dispose() {
    _seedController.dispose();
    _coordController.dispose();
    super.dispose();
  }
}
