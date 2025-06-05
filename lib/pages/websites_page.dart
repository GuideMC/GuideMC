import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WebsitesPage extends StatefulWidget {
  const WebsitesPage({super.key});

  @override
  State<WebsitesPage> createState() => _WebsitesPageState();
}

class _WebsitesPageState extends State<WebsitesPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    final crossAxisCount = screenWidth > 1200
        ? 3
        : screenWidth > 800
        ? 2
        : 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('常用网站'),
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
                      'Minecraft常用网站',
                      style: isWideScreen
                          ? Theme.of(context).textTheme.headlineSmall
                          : Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '收集了Minecraft相关的常用网站链接',
                      style: isWideScreen
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isWideScreen && crossAxisCount > 1)
              _buildGridLayout(crossAxisCount)
            else
              _buildListLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildGridLayout(int crossAxisCount) {
    final categories = _getCategories();
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: categories.entries.map((entry) {
        return SizedBox(
          width: crossAxisCount == 3 ? 300 : 400,
          child: _buildCategoryCard(entry.key, entry.value),
        );
      }).toList(),
    );
  }

  Widget _buildListLayout() {
    final categories = _getCategories();
    return Column(
      children: categories.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildCategoryCard(entry.key, entry.value),
        );
      }).toList(),
    );
  }

  Map<String, List<_WebsiteItem>> _getCategories() {
    return {
      '官方网站': [
        _WebsiteItem(
          'Minecraft官网',
          'https://www.minecraft.net/',
          '游戏官方网站',
          Icons.home,
          Colors.green,
        ),
        _WebsiteItem(
          'Mojang Studios',
          'https://www.mojang.com/',
          'Minecraft开发商',
          Icons.business,
          Colors.red,
        ),
      ],
      '模组网站': [
        _WebsiteItem(
          'CurseForge',
          'https://www.curseforge.com/minecraft',
          '最大的模组下载网站',
          Icons.extension,
          Colors.orange,
        ),
        _WebsiteItem(
          'Modrinth',
          'https://modrinth.com/',
          '新兴的模组平台',
          Icons.rocket_launch,
          Colors.green,
        ),
        _WebsiteItem(
          'MC百科',
          'https://www.mcmod.cn/',
          '中文模组百科',
          Icons.menu_book,
          Colors.blue,
        ),
      ],
      '服务器': [
        _WebsiteItem(
          'Hypixel',
          'https://hypixel.net/',
          '知名服务器',
          Icons.dns,
          Colors.yellow,
        ),
        _WebsiteItem(
          '服务器列表',
          'https://minecraft-server-list.com/',
          '服务器列表网站',
          Icons.list,
          Colors.purple,
        ),
      ],
      '皮肤和材质': [
        _WebsiteItem(
          'NameMC',
          'https://namemc.com/',
          '皮肤查看和下载',
          Icons.person,
          Colors.indigo,
        ),
        _WebsiteItem(
          'Nova Skin',
          'https://minecraft.novaskin.me/',
          '皮肤编辑器',
          Icons.edit,
          Colors.pink,
        ),
        _WebsiteItem(
          'Planet Minecraft',
          'https://www.planetminecraft.com/',
          '皮肤、建筑、地图分享',
          Icons.public,
          Colors.cyan,
        ),
      ],
      '工具网站': [
        _WebsiteItem(
          'Minecraft Wiki',
          'https://minecraft.fandom.com/',
          '官方维基百科',
          Icons.article,
          Colors.brown,
        ),
        _WebsiteItem(
          'Chunk Base',
          'https://www.chunkbase.com/',
          '种子查找工具',
          Icons.map,
          Colors.teal,
        ),
        _WebsiteItem(
          'MCreator',
          'https://mcreator.net/',
          '模组制作工具',
          Icons.build,
          Colors.deepOrange,
        ),
        _WebsiteItem(
          'BlockBench',
          'https://www.blockbench.net/',
          '3D模型编辑器',
          Icons.view_in_ar,
          Colors.indigo,
        ),
      ],
    };
  }

  Widget _buildCategoryCard(String title, List<_WebsiteItem> websites) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          ...websites.map((website) => _buildWebsiteCard(website)).toList(),
        ],
      ),
    );
  }

  Widget _buildWebsiteCard(_WebsiteItem website) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: website.color,
        child: Icon(website.icon, color: Colors.white, size: 20),
      ),
      title: Text(website.name),
      subtitle: Text(website.description),
      trailing: const Icon(Icons.open_in_new),
      onTap: () => _copyURL(website.url, website.name),
    );
  }

  Future<void> _copyURL(String url, String name) async {
    await Clipboard.setData(ClipboardData(text: url));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name 链接已复制到剪贴板'),
          action: SnackBarAction(label: '确定', onPressed: () {}),
        ),
      );
    }
  }
}

class _WebsiteItem {
  final String name;
  final String url;
  final String description;
  final IconData icon;
  final Color color;

  _WebsiteItem(this.name, this.url, this.description, this.icon, this.color);
}
