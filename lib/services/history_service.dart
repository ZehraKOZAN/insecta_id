// lib/services/history_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/analysis_result.dart';

class HistoryService {
  static const String _key = 'analysis_history';

  Future<List<AnalysisResult>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((j) => AnalysisResult.fromJson(jsonDecode(j)))
        .toList()
        .reversed
        .toList();
  }

  Future<void> saveResult(AnalysisResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    jsonList.add(jsonEncode(result.toJson()));
    // Son 50 kaydı tut
    if (jsonList.length > 50) jsonList.removeAt(0);
    await prefs.setStringList(_key, jsonList);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}