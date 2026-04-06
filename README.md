# EduTrack: Smart Attendance Management App 🎓📱

EduTrack is a modern, professional, and secure attendance management solution built with **Flutter**. It eliminates manual entry errors and prevents proxy attendance using session-based **QR Codes** and **GPS/Location Validation**.

---

## 🚀 Key Features

- **🔐 Secure QR Scanning**: Periodic, time-bound QR codes for every class session.
- **📍 GPS Distance Validation**: Automatically calculates the distance between the student and instructor to prevent remote/proxy attendance.
- **⌨️ Manual Entry Fallback**: 6-digit session codes for cases where students have camera hardware issues or permission restrictions.
- **📶 Offline Data Persistence**: Records are saved locally using **SharedPreferences** and can be synced later.
- **📊 Professional Dashboards**:
  - **Instructor Dashboard**: Create sessions, monitor live attendance, and view fraud alerts.
  - **Student Portfolio**: Scan active sessions, check history, and track sync status.
  - **Admin Analytics**: Real-time reports and audit logs for academic monitoring.
- **✨ Premium UI/UX**: Clean **Material 3** design with custom branding, responsive layouts (Mobile/Web), and intuitive workflows.

---

## 🛠️ Technology Stack

| Component | Technology |
| :--- | :--- |
| **Framework** | Flutter (Dart SDK ^3.8.0) |
| **State Management** | `provider` |
| **QR Functionality** | `qr_flutter` & `mobile_scanner` |
| **Location Tracking** | `geolocator` |
| **Storage** | `shared_preferences` |
| **Utilities** | `uuid`, `intl`, `http` |

---

## 🖥️ Screen Roles

### 1. Instructor
- **Generate Session**: Set course name, duration (minutes), and maximum allowed distance (meters).
- **Control**: Toggle Flash/Camera for QR display.
- **Reports**: View real-time participation and fraud detection.

### 2. Student
- **Capture Attendance**: High-speed camera scanning.
- **Fallback**: Manual keypad for 6-digit session codes.
- **History**: Local cache of all past attendance records with "Sync" status.

---

## ⚙️ Getting Started

1.  **Clone the Repository**:
    ```bash
    git clone https://github.com/Anjali-patel27/Smart-Attendance-Management-App.git
    ```
2.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the Application**:
    ```bash
    flutter run
    ```

---

## 🛡️ Anti-Proxy Validation Logic
```dart
// Core Logic used in the app to prevent false attendance
final distance = calculateDistance(sessionLat, sessionLng, studentLat, studentLng);
if (distance > sessionRadius) {
  flagAsFraudulent(); // Attendance is recorded but marked for manual audit
}
```

---

## 📄 License
Designed and Developed for **EduTrack Systems**. All rights reserved.
