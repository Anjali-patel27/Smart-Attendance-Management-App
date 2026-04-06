import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';
import '../services/db_service.dart';
import '../services/api_service.dart';
import '../services/location_service.dart';

class AppProvider extends ChangeNotifier {
  final DbService _dbService = DbService();
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  List<AttendanceSession> _sessions = [];
  List<AttendanceSession> get sessions => _sessions;

  List<AttendanceRecord> _records = [];
  List<AttendanceRecord> get records => _records;

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  Future<void> init() async {
    _records = await _dbService.getRecords();
    notifyListeners();
  }

  void login(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Instructor methods
  void createSession(String courseName, int durationMinutes, double lat, double lng, double radius) {
    if (_currentUser?.role != 'instructor') return;
    
    final newSession = AttendanceSession(
      id: const Uuid().v4(),
      courseName: courseName,
      instructorId: _currentUser!.id,
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(minutes: durationMinutes)),
      lat: lat,
      lng: lng,
      radius: radius,
    );
    _sessions.add(newSession);
    notifyListeners();
  }

  // Student methods
  Future<String> markAttendance(AttendanceSession session) async {
    if (_currentUser?.role != 'student') return "User not a student";
    
    if (!session.isValid) {
      return "Session expired";
    }

    final pos = await _locationService.getCurrentLocation();
    if (pos == null) {
      return "Location permission denied or disabled";
    }

    final distance = _locationService.calculateDistance(
      session.lat, session.lng, pos.latitude, pos.longitude
    );

    bool isFraudulent = distance > session.radius;

    final record = AttendanceRecord(
      id: const Uuid().v4(),
      sessionId: session.id,
      studentId: _currentUser!.id,
      studentName: _currentUser!.name,
      timestamp: DateTime.now(),
      isFraudulent: isFraudulent,
    );

    await _dbService.saveRecord(record);
    _records = await _dbService.getRecords();
    notifyListeners();

    if (isFraudulent) {
      return "Attendance marked, but flagged as fraudulent (out of range: ${distance.toStringAsFixed(2)}m)";
    }
    return "Attendance marked successfully";
  }

  // Admin / Sync methods
  Future<void> syncRecords() async {
    if (_isSyncing) return;
    
    final unsynced = await _dbService.getUnsyncedRecords();
    if (unsynced.isEmpty) return;

    _isSyncing = true;
    notifyListeners();

    try {
      final success = await _apiService.syncRecords(unsynced);
      if (success) {
        final syncedIds = unsynced.map((r) => r.id).toList();
        await _dbService.updateRecordsAsSynced(syncedIds);
        _records = await _dbService.getRecords();
      }
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  List<AttendanceRecord> getRecordsForSession(String sessionId) {
    return _records.where((r) => r.sessionId == sessionId).toList();
  }
}
