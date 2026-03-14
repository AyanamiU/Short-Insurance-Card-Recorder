import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/theme/theme_controller.dart';
import '../records/records_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const _SectionTitle('主题设置'),
          RadioListTile<ThemeMode>(
            value: ThemeMode.system,
            groupValue: themeController.themeMode,
            title: const Text('跟随系统'),
            onChanged: (value) => themeController.setThemeMode(value!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.light,
            groupValue: themeController.themeMode,
            title: const Text('浅色模式'),
            onChanged: (value) => themeController.setThemeMode(value!),
          ),
          RadioListTile<ThemeMode>(
            value: ThemeMode.dark,
            groupValue: themeController.themeMode,
            title: const Text('深色模式'),
            onChanged: (value) => themeController.setThemeMode(value!),
          ),
          const Divider(),
          const _SectionTitle('数据管理'),
          ListTile(
            leading: const Icon(Icons.upload_file_outlined),
            title: const Text('导出 JSON 记录'),
            onTap: () async {
              final path = await context.read<RecordsController>().exportJson();
              if (context.mounted) {
                _showMessage(context, '导出成功，文件已保存到：$path');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: const Text('导入 JSON 记录'),
            onTap: () async {
              try {
                final count =
                    await context.read<RecordsController>().importJson();
                if (context.mounted)
                  _showMessage(
                      context, count == 0 ? '未选择文件' : '成功导入 $count 条记录');
              } catch (_) {
                if (context.mounted)
                  _showMessage(context, '导入失败，请检查 JSON 文件格式是否正确');
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('清空全部记录'),
            onTap: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('清空数据'),
                  content: const Text('确认清空全部短险卡记录吗？'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('取消')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('确认')),
                  ],
                ),
              );
              if (ok == true) {
                await context.read<RecordsController>().clearAll();
                if (context.mounted) _showMessage(context, '数据已清空');
              }
            },
          ),
          const Divider(),
          const AboutListTile(
            icon: Icon(Icons.info_outline),
            applicationName: '短险卡记录',
            applicationVersion: '1.0.0',
            aboutBoxChildren: [Text('基于 Flutter/Dart 的短险卡记录软件。')],
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
