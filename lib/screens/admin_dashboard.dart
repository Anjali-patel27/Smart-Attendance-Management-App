import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import 'package:intl/intl.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final records = provider.records;

    // Basic Analytics
    int totalAttendance = records.length;
    int fraudulentCount = records.where((r) => r.isFraudulent).length;
    int syncedCount = records.where((r) => r.isSynced).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard & Analytics'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Total', totalAttendance.toString(), Colors.blue),
                _buildStatCard('Fraudulent', fraudulentCount.toString(), Colors.red),
                _buildStatCard('Synced', syncedCount.toString(), Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Attendance Records / Audit Trail',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: Icon(
                        record.isFraudulent ? Icons.warning : Icons.check_circle,
                        color: record.isFraudulent ? Colors.red : Colors.green,
                      ),
                      title: Text('${record.studentName} (${record.studentId})'),
                      subtitle: Text(
                        'Session: ${record.sessionId.substring(0, 8)}...\n'
                        'Time: ${DateFormat('yyyy-MM-dd HH:mm').format(record.timestamp)}',
                      ),
                      trailing: record.isSynced 
                        ? const Icon(Icons.cloud_done, color: Colors.blue) 
                        : const Icon(Icons.cloud_off, color: Colors.grey),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 100,
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
