import 'dart:convert';

class User {
  final String id;
  final String name;
  final String role; // 'student' or 'instructor'
  final String? studentId;

  User({required this.id, required this.name, required this.role, this.studentId});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      studentId: json['studentId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'studentId': studentId,
    };
  }
}

class AttendanceSession {
  final String id;
  final String courseName;
  final String instructorId;
  final DateTime startTime;
  final DateTime endTime;
  final double lat;
  final double lng;
  final double radius; // allowed radius in meters

  AttendanceSession({
    required this.id,
    required this.courseName,
    required this.instructorId,
    required this.startTime,
    required this.endTime,
    required this.lat,
    required this.lng,
    required this.radius,
  });

  factory AttendanceSession.fromJson(Map<String, dynamic> json) {
    return AttendanceSession(
      id: json['id'],
      courseName: json['courseName'],
      instructorId: json['instructorId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      lat: json['lat'],
      lng: json['lng'],
      radius: json['radius'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'instructorId': instructorId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'lat': lat,
      'lng': lng,
      'radius': radius,
    };
  }
  
  bool get isValid => DateTime.now().isBefore(endTime) && DateTime.now().isAfter(startTime);
  
  String toQrData() {
    return jsonEncode(toJson());
  }
}

class AttendanceRecord {
  final String id;
  final String sessionId;
  final String studentId;
  final String studentName;
  final DateTime timestamp;
  final bool isSynced;
  final bool isFraudulent;

  AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.timestamp,
    this.isSynced = false,
    this.isFraudulent = false,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id'],
      sessionId: json['sessionId'],
      studentId: json['studentId'],
      studentName: json['studentName'],
      timestamp: DateTime.parse(json['timestamp']),
      isSynced: json['isSynced'] ?? false,
      isFraudulent: json['isFraudulent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'studentId': studentId,
      'studentName': studentName,
      'timestamp': timestamp.toIso8601String(),
      'isSynced': isSynced,
      'isFraudulent': isFraudulent,
    };
  }

  AttendanceRecord copyWith({
    String? id,
    String? sessionId,
    String? studentId,
    String? studentName,
    DateTime? timestamp,
    bool? isSynced,
    bool? isFraudulent,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      isFraudulent: isFraudulent ?? this.isFraudulent,
    );
  }
}
