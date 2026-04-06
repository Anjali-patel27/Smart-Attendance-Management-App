import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class DbService {
  static const String recordsKey = 'attendance_records';

  Future<void> saveRecord(AttendanceRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recordsList = prefs.getStringList(recordsKey) ?? [];
    
    // Check if record for this session by this student already exists locally
    final existingIndex = recordsList.indexWhere((r) {
      final parsed = AttendanceRecord.fromJson(jsonDecode(r));
      return parsed.sessionId == record.sessionId && parsed.studentId == record.studentId;
    });

    if (existingIndex != -1) {
      recordsList[existingIndex] = jsonEncode(record.toJson());
    } else {
      recordsList.add(jsonEncode(record.toJson()));
    }
    
    await prefs.setStringList(recordsKey, recordsList);
  }

  Future<List<AttendanceRecord>> getRecords() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recordsList = prefs.getStringList(recordsKey) ?? [];
    return recordsList.map((str) => AttendanceRecord.fromJson(jsonDecode(str))).toList();
  }

  Future<List<AttendanceRecord>> getUnsyncedRecords() async {
    final records = await getRecords();
    return records.where((r) => !r.isSynced).toList();
  }

  Future<void> updateRecordsAsSynced(List<String> syncedIds) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recordsList = prefs.getStringList(recordsKey) ?? [];
    List<String> updatedList = [];
    
    for (String str in recordsList) {
      final record = AttendanceRecord.fromJson(jsonDecode(str));
      if (syncedIds.contains(record.id)) {
        updatedList.add(jsonEncode(record.copyWith(isSynced: true).toJson()));
      } else {
        updatedList.add(str);
      }
    }
    
    await prefs.setStringList(recordsKey, updatedList);
  }
}
