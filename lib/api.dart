import 'dart:convert';
import 'package:flutter/services.dart';

Future<Map<String, dynamic>> loadJsonFromAssets() async {
  String jsonString = await rootBundle.loadString('assets/api_key.json');
  return jsonDecode(jsonString);
}

Future<String> getNasaApiKey() async {
  Map<String, dynamic> jsonData = await loadJsonFromAssets();
  return jsonData['nasa'];
}
