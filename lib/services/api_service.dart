import 'dart:convert';
import 'dart:math';
import '../models/models.dart';
import 'package:uuid/uuid.dart';

class ApiService {
  // Mock API service for backend sync
  Future<bool> syncRecords(List<AttendanceRecord> records) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // Simulate a successful sync 90% of the time
    if (records.isEmpty) return true;
    final random = Random();
    if (random.nextInt(100) < 10) {
      return false; // Sync failed
    }
    return true; // Sync succeeded
  }

  // Mock fetching sessions for an instructor
  Future<List<AttendanceSession>> fetchInstructorSessions(String instructorId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Usually these would come from standard DB. We just return a mock list or load from shared prefs.
    // For simplicity, we just rely on state provider to hold them in memory.
    return [];
  }
}
