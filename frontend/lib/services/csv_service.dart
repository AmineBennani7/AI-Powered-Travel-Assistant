import 'dart:convert';
import 'package:flutter/services.dart';

class CsvService {
  static final CsvService instance = CsvService._internal();
  CsvService._internal();

  List<String> _businessNames = [];

  List<String> get businessNames => _businessNames;

  Future<void> loadCsvData() async {
    final String rawData = await rootBundle.loadString('assets/data/oxforddata.csv');
    final List<String> lines = const LineSplitter().convert(rawData);

    _businessNames = lines
        .skip(1) // Skip the header row
        .map((line) {
          final fields = line.split(',');
          return fields.length > 1 ? fields[1].trim() : null; // Only take field 1 (BusinessName)
        })
        .whereType<String>() // Remove any nulls
        .toList();
  }

  String getRandomBusinessName() {
    if (_businessNames.isEmpty) return "Unknown Place";
    _businessNames.shuffle();
    return _businessNames.first;
  }
}
