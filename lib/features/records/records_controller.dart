import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../shared/models/insurance_record.dart';
import '../../shared/storage/app_repository.dart';

class RecordsController extends ChangeNotifier {
  RecordsController(this._repository);

  final AppRepository _repository;
  final List<InsuranceRecord> _records = [];
  String _keyword = '';
  String? errorMessage;

  List<InsuranceRecord> get records {
    final query = _keyword.trim().toLowerCase();
    if (query.isEmpty) return List.unmodifiable(_records);
    return _records.where((record) {
      return record.name.toLowerCase().contains(query) ||
          record.idNumber.toLowerCase().contains(query) ||
          record.policyNumber.toLowerCase().contains(query) ||
          record.insuranceType.toLowerCase().contains(query);
    }).toList(growable: false);
  }

  Future<void> load() async {
    try {
      errorMessage = null;
      _records
        ..clear()
        ..addAll(_repository.loadRecords());
    } catch (e) {
      errorMessage = '加载记录失败：$e';
    }
    notifyListeners();
  }

  void search(String keyword) {
    _keyword = keyword;
    notifyListeners();
  }

  Future<void> upsert(InsuranceRecord record) async {
    await _repository.saveRecord(record);
    await load();
  }

  Future<void> remove(String id) async {
    await _repository.deleteRecord(id);
    await load();
  }

  Future<String> exportJson() => _repository.exportRecords();

  Future<int> importJson() async {
    final count = await _repository.importRecords();
    await load();
    return count;
  }

  Future<void> clearAll() async {
    await _repository.clearAllRecords();
    await load();
  }

  String nextId() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999).toString().padLeft(6, '0');
    return '$now$random';
  }
}

