import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quiz_result.dart';

class StorageService {
  static const String _key = 'quiz_history';

  static Future<void> saveQuizResult(QuizResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getQuizHistory();
    history.add(result);
    
    final jsonList = history.map((r) => r.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  static Future<List<QuizResult>> getQuizHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    
    if (jsonString == null) {
      return [];
    }
    
    final jsonList = jsonDecode(jsonString) as List;
    return jsonList.map((json) => QuizResult.fromJson(json)).toList();
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

