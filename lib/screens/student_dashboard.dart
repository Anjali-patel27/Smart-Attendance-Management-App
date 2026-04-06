import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';
import 'qr_scanner_screen.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.read<AppProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user?.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppProvider>().logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.qr_code_scanner, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => QRScannerScreen()));
              },
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
              child: const Text('Scan QR to Mark Attendance', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await context.read<AppProvider>().syncRecords();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Syncing done.')));
              },
              child: const Text('Sync Offline Records'),
            )
          ],
        ),
      ),
    );
  }
}
