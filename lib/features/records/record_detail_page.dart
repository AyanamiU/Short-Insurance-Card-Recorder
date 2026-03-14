import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../shared/models/insurance_record.dart';
import 'record_form_page.dart';
import 'records_controller.dart';

class RecordDetailPage extends StatelessWidget {
  const RecordDetailPage({super.key, required this.record});

  final InsuranceRecord record;

  @override
  Widget build(BuildContext context) {
    final items = {
      '姓名': record.name,
      '保险类型': record.insuranceType,
      '证件号码': record.idNumber,
      '保险费用': record.premium.toStringAsFixed(2),
      '保险日期': DateFormat('yyyy-MM-dd').format(record.insuranceDate),
      '手机号码': record.phone,
      '投保人': record.policyHolder,
      '受保人': record.insuredPerson,
      '保单号': record.policyNumber,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('记录详情'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => RecordFormPage(existing: record)),
            ),
            icon: const Icon(Icons.edit_outlined),
          ),
          IconButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('删除记录'),
                  content: const Text('确认删除这条记录吗？此操作不可撤销。'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('删除')),
                  ],
                ),
              );
              if (confirmed == true && context.mounted) {
                await context.read<RecordsController>().remove(record.id);
                if (context.mounted) Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items.entries
            .map((entry) => Card(
                  child: ListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value.isEmpty ? '未填写' : entry.value),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

