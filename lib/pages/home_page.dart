import 'package:flutter/material.dart';
import 'java_download_page.dart';
import 'launcher_page.dart';
import 'mod_manager_page.dart';
import 'websites_page.dart';
import 'utils_page.dart';
import 'download_manager_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const MainPage(),
    const JavaDownloadPage(),
    const LauncherPage(),
    const ModManagerPage(),
    const UtilsPage(),
    const WebsitesPage(),
    const DownloadManagerPage(),
    const SettingsPage(),
  ];

  void updateSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    if (isWideScreen) {
      // 平板和桌面布局 - 使用侧边导航
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('主页'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.download),
                  label: Text('Java下载'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.rocket_launch),
                  label: Text('启动器'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.folder_zip),
                  label: Text('模组管理'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.build),
                  label: Text('实用工具'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.language),
                  label: Text('常用网站'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.download_for_offline),
                  label: Text('下载管理'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('设置'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      );
    } else {
      // 手机布局 - 使用底部导航
      return Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home), label: '主页'),
            NavigationDestination(icon: Icon(Icons.download), label: 'Java下载'),
            NavigationDestination(
              icon: Icon(Icons.rocket_launch),
              label: '启动器',
            ),
            NavigationDestination(icon: Icon(Icons.folder_zip), label: '模组管理'),
            NavigationDestination(icon: Icon(Icons.build), label: '实用工具'),
            NavigationDestination(icon: Icon(Icons.language), label: '常用网站'),
            NavigationDestination(
              icon: Icon(Icons.download_for_offline),
              label: '下载管理',
            ),
            NavigationDestination(icon: Icon(Icons.settings), label: '设置'),
          ],
        ),
      );
    }
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 1200
        ? 4
        : screenWidth > 800
        ? 3
        : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MC助手'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: screenWidth > 600 ? 4 : 2,
              child: Padding(
                padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '欢迎使用MC助手',
                      style: screenWidth > 600
                          ? Theme.of(context).textTheme.headlineMedium
                          : Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '一站式Minecraft管理工具，提供Java环境、启动器管理、模组识别等功能。',
                      style: screenWidth > 600
                          ? Theme.of(context).textTheme.bodyLarge
                          : Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '快速功能',
              style: screenWidth > 600
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: screenWidth > 600 ? 16 : 8,
                mainAxisSpacing: screenWidth > 600 ? 16 : 8,
                childAspectRatio: screenWidth > 600 ? 1.2 : 1.0,
                children: [
                  _buildQuickActionCard(
                    context,
                    Icons.download,
                    'Java下载',
                    '下载和管理Java运行环境',
                    () => _navigateToPage(context, 1),
                  ),
                  _buildQuickActionCard(
                    context,
                    Icons.rocket_launch,
                    '启动器管理',
                    '管理Minecraft启动器',
                    () => _navigateToPage(context, 2),
                  ),
                  _buildQuickActionCard(
                    context,
                    Icons.folder_zip,
                    '模组识别',
                    '识别整合包、光影等内容',
                    () => _navigateToPage(context, 3),
                  ),
                  _buildQuickActionCard(
                    context,
                    Icons.build,
                    '实用工具',
                    '种子生成器和坐标转换',
                    () => _navigateToPage(context, 4),
                  ),
                  _buildQuickActionCard(
                    context,
                    Icons.language,
                    '常用网站',
                    '访问MC相关网站',
                    () => _navigateToPage(context, 5),
                  ),
                  _buildQuickActionCard(
                    context,
                    Icons.download_for_offline,
                    '下载管理',
                    '管理文件下载和识别',
                    () => _navigateToPage(context, 6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    final homePageState = context.findAncestorStateOfType<_HomePageState>();
    if (homePageState != null) {
      homePageState.updateSelectedIndex(index);
    }
  }
}
