import 'package:flutter/material.dart';

import '../../shared/storage/app_repository.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._repository);

  final AppRepository _repository;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    _themeMode = _repository.loadThemeMode();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _repository.saveThemeMode(mode);
    notifyListeners();
  }
}

