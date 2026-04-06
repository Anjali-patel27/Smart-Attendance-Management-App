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
        title: const Text('Attendance Audit & Insights', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildStatCard('TOTAL REG.', totalAttendance.toString(), Colors.blue[800]!)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('FRAUD DETECTED', fraudulentCount.toString(), Colors.red[800]!)),
                const SizedBox(width: 10),
                Expanded(child: _buildStatCard('CLOUD SYNCED', syncedCount.toString(), Colors.green[800]!)),
              ],
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Icon(Icons.list_alt, size: 20, color: Colors.blueGrey),
                const SizedBox(width: 10),
                const Text('DETAILED AUDIT LOG', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.blueGrey)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {}, 
                  icon: const Icon(Icons.download, size: 16), 
                  label: const Text('EXPORT', style: TextStyle(fontSize: 12))
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: records.isEmpty 
              ? const Center(child: Text('No attendance events to report.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[records.length - 1 - index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor: record.isFraudulent ? Colors.red[50] : Colors.green[50],
                        child: Icon(
                          record.isFraudulent ? Icons.security : Icons.person,
                          color: record.isFraudulent ? Colors.red : Colors.green,
                          size: 18,
                        ),
                      ),
                      title: Text('${record.studentName}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${record.studentId} | Session: ${record.sessionId.substring(0, 8)}'),
                          Text(DateFormat('MMM dd, yyyy - HH:mm').format(record.timestamp), style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                      trailing: record.isSynced 
                        ? const Icon(Icons.cloud_done, color: Colors.blue, size: 20) 
                        : const Icon(Icons.cloud_off, color: Colors.grey, size: 20),
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          ],
        ),
      ),
    );
  }
}
