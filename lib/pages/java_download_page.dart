import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JavaDownloadPage extends StatefulWidget {
  const JavaDownloadPage({super.key});

  @override
  State<JavaDownloadPage> createState() => _JavaDownloadPageState();
}

class _JavaDownloadPageState extends State<JavaDownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Java下载'),
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
                      'Java运行环境下载',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text('选择适合你Minecraft版本的Java运行环境'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildJavaVersionCard(
              context,
              'Java 8',
              '适用于 Minecraft 1.16 及以下版本',
              'https://www.oracle.com/java/technologies/javase/javase8-archive-downloads.html',
              Colors.orange,
            ),
            _buildJavaVersionCard(
              context,
              'Java 17',
              '适用于 Minecraft 1.17-1.20 版本',
              'https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html',
              Colors.blue,
            ),
            _buildJavaVersionCard(
              context,
              'Java 21',
              '适用于 Minecraft 1.20+ 版本',
              'https://www.oracle.com/java/technologies/javase/jdk21-archive-downloads.html',
              Colors.green,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '其他Java发行版',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    _buildDownloadButton(
                      'OpenJDK (免费)',
                      'https://adoptium.net/',
                      Icons.download,
                    ),
                    _buildDownloadButton(
                      'Azul Zulu (推荐)',
                      'https://www.azul.com/downloads/',
                      Icons.download,
                    ),
                    _buildDownloadButton(
                      'Microsoft OpenJDK',
                      'https://docs.microsoft.com/zh-cn/java/openjdk/download',
                      Icons.download,
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

  Widget _buildJavaVersionCard(
    BuildContext context,
    String version,
    String description,
    String url,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            version.split(' ')[1],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(version),
        subtitle: Text(description),
        trailing: const Icon(Icons.download),
        onTap: () => _launchURL(url),
      ),
    );
  }

  Widget _buildDownloadButton(String title, String url, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => _launchURL(url),
    );
  }

  Future<void> _launchURL(String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('链接已复制到剪贴板: $url'),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
    }
  }
}
