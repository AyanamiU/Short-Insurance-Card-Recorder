import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/insurance_record.dart';

class AppRepository {
  AppRepository._(this._recordsBox, this._settingsBox);

  final Box _recordsBox;
  final Box _settingsBox;

  static Future<AppRepository> create() async {
    final records = await Hive.openBox('records_box');
    final settings = await Hive.openBox('settings_box');
    return AppRepository._(records, settings);
  }

  List<InsuranceRecord> loadRecords() => _recordsBox.values
      .map((item) =>
          InsuranceRecord.fromJson(Map<String, dynamic>.from(item as Map)))
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> saveRecord(InsuranceRecord record) async {
    await _recordsBox.put(record.id, record.toJson());
  }

  Future<void> deleteRecord(String id) => _recordsBox.delete(id);

  ThemeMode loadThemeMode() {
    final value =
        _settingsBox.get('themeMode', defaultValue: 'system') as String;
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) =>
      _settingsBox.put('themeMode', mode.name);

  Future<String> exportRecords() async {
    final file = await _resolveExportFile();
    final content = jsonEncode(loadRecords().map((e) => e.toJson()).toList());
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
    return file.path;
  }

  Future<File> _resolveExportFile() async {
    if (Platform.isAndroid) {
      return File('/storage/emulated/0/Documents/short_insurance_export.json');
    }
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/short_insurance_export.json');
  }

  Future<int> importRecords() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result == null || result.files.single.path == null) return 0;
    final file = File(result.files.single.path!);
    final data = jsonDecode(await file.readAsString()) as List<dynamic>;
    for (final item in data) {
      final record =
          InsuranceRecord.fromJson(Map<String, dynamic>.from(item as Map));
      await saveRecord(record);
    }
    return data.length;
  }

  Future<void> clearAllRecords() => _recordsBox.clear();
}
