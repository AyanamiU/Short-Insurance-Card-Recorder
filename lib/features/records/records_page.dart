import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/models/insurance_record.dart';
import 'record_detail_page.dart';
import 'record_form_page.dart';
import 'records_controller.dart';

class RecordsPage extends StatelessWidget {
  const RecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RecordsController>();
    final records = controller.records;
    return Scaffold(
      appBar: AppBar(
        title: const Text('短险卡记录'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const RecordFormPage()),
            ),
            icon: const Icon(Icons.add),
            tooltip: '新建',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: '搜索姓名、证件号、保单号、保险类型',
              leading: const Icon(Icons.search),
              onChanged: controller.search,
            ),
          ),
          if (controller.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(controller.errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(
            child: records.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (_, index) => _RecordTile(record: records[index]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RecordFormPage())),
        icon: const Icon(Icons.note_add_outlined),
        label: const Text('添加记录'),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final InsuranceRecord record;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy-MM-dd').format(record.insuranceDate);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(record.name),
        subtitle: Text('${record.insuranceType}｜$date\n证件号：${record.idNumber}'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RecordDetailPage(record: record)),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 72, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 12),
          const Text('暂无记录'),
          const SizedBox(height: 8),
          Text('点击右下角按钮开始创建第一条短险卡记录', style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

