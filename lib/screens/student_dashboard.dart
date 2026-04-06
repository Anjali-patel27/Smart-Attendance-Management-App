import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';
import 'qr_scanner_screen.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EduTrack: Student Portfolio', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              context.read<AppProvider>().logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUserHeader(user?.name ?? 'Student'),
              const SizedBox(height: 25),
              _buildMainActionCard(context),
              const SizedBox(height: 25),
              _buildStatusCard(provider),
              const SizedBox(height: 20),
              _buildHistoryHeader(),
              const SizedBox(height: 10),
              _buildRecentActivity(provider),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(String name) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50], 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[800],
            radius: 30,
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, $name', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Text('Active Student | EduTrack', style: TextStyle(color: Colors.blueGrey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMainActionCard(BuildContext context) {
    return Card(
      color: Colors.blue[800],
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            const Icon(Icons.qr_code_scanner, size: 60, color: Colors.white),
            const SizedBox(height: 15),
            const Text(
              'Capture Attendance',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Scan class QR code to mark your presence',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => QRScannerScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue[900],
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Start Scanner', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(AppProvider provider) {
    final unsynced = provider.records.where((r) => !r.isSynced).length;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: unsynced > 0 ? Colors.orange[100] : Colors.green[100],
          child: Icon(
            unsynced > 0 ? Icons.sync_problem : Icons.sync,
            color: unsynced > 0 ? Colors.orange[800] : Colors.green[800],
          ),
        ),
        title: const Text('Sync Progress', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(unsynced > 0 ? '$unsynced records waiting for sync' : 'All records synced to cloud'),
        trailing: TextButton(
          onPressed: () async {
            await provider.syncRecords();
          },
          child: Text(provider.isSyncing ? 'Syncing...' : 'Sync Now'),
        ),
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return const Row(
      children: [
        Icon(Icons.history, size: 20, color: Colors.blueGrey),
        SizedBox(width: 5),
        Text('RECENT LOGS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.1, color: Colors.blueGrey)),
      ],
    );
  }

  Widget _buildRecentActivity(AppProvider provider) {
    if (provider.records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text('No attendance records yet', style: TextStyle(color: Colors.grey))),
      );
    }
    
    return Column(
      children: provider.records.reversed.take(5).map((record) {
        return Card(
          elevation: 1,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: Icon(record.isFraudulent ? Icons.error_outline : Icons.check_circle_outline, color: record.isFraudulent ? Colors.red : Colors.green),
            title: Text(record.sessionId.substring(0, 8)),
            subtitle: Text(record.timestamp.toString().substring(0, 16)),
            trailing: record.isSynced ? const Icon(Icons.cloud_done, size: 16, color: Colors.blue) : const Icon(Icons.cloud_off, size: 16, color: Colors.grey),
          ),
        );
      }).toList(),
    );
  }
}
