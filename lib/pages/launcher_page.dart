import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LauncherPage extends StatefulWidget {
  const LauncherPage({super.key});

  @override
  State<LauncherPage> createState() => _LauncherPageState();
}

class _LauncherPageState extends State<LauncherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('启动器管理'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Minecraft启动器',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('选择适合你的Minecraft启动器'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLauncherCard(
              context,
              'Minecraft官方启动器',
              '官方启动器，支持正版验证',
              'https://www.minecraft.net/zh-hans/download',
              Icons.verified,
              Colors.green,
            ),
            _buildLauncherCard(
              context,
              'MultiMC',
              '轻量级第三方启动器，支持多版本管理',
              'https://multimc.org/',
              Icons.apps,
              Colors.blue,
            ),
            _buildLauncherCard(
              context,
              'PolyMC',
              'MultiMC的分支，功能更强大',
              'https://polymc.org/',
              Icons.extension,
              Colors.purple,
            ),
            _buildLauncherCard(
              context,
              'PCL2',
              '国内流行的第三方启动器',
              'https://afdian.net/@LTCat',
              Icons.rocket_launch,
              Colors.orange,
            ),
            _buildLauncherCard(
              context,
              'HMCL',
              'Hello Minecraft! Launcher',
              'https://hmcl.huangyuhui.net/',
              Icons.star,
              Colors.red,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '启动器功能说明',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('版本管理'),
                      subtitle: Text('安装和管理不同的Minecraft版本'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('模组支持'),
                      subtitle: Text('安装Forge、Fabric等模组加载器'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('账户管理'),
                      subtitle: Text('管理正版和离线账户'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('游戏设置'),
                      subtitle: Text('配置内存、JVM参数等'),
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

  Widget _buildLauncherCard(
    BuildContext context,
    String name,
    String description,
    String url,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(name),
        subtitle: Text(description),
        trailing: const Icon(Icons.download),
        onTap: () => _copyURL(url, name),
      ),
    );
  }

  Future<void> _copyURL(String url, String name) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name 下载链接已复制到剪贴板'),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
    }
  }
}
