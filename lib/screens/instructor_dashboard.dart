import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';
import 'qr_generator_screen.dart';
import '../services/location_service.dart';
import 'admin_dashboard.dart';

class InstructorDashboard extends StatelessWidget {
  final _courseController = TextEditingController();
  final _durationController = TextEditingController(text: "15");
  final _radiusController = TextEditingController(text: "50");

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('EduTrack: Instructor', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
            },
            tooltip: 'View Reports',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              provider.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
            },
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            // Tablet/Desktop Horizontal
            return Row(
              children: [
                SizedBox(width: 350, child: _buildCreationPanel(context, provider)),
                const VerticalDivider(width: 1),
                Expanded(child: _buildSessionHistory(context, provider)),
              ],
            );
          } else {
            // Mobile Vertical
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildCreationPanel(context, provider),
                  const Divider(),
                  SizedBox(height: 400, child: _buildSessionHistory(context, provider)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCreationPanel(BuildContext context, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('New Attendance Session', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 20),
          TextField(
            controller: _courseController, 
            decoration: const InputDecoration(labelText: 'Course Name', prefixIcon: Icon(Icons.class_)),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _durationController, 
            decoration: const InputDecoration(labelText: 'Duration (minutes)', prefixIcon: Icon(Icons.timer)),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _radiusController, 
            decoration: const InputDecoration(labelText: 'Distance Limit (m)', prefixIcon: Icon(Icons.gps_fixed)),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: () async {
              if (_courseController.text.trim().isEmpty) {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a course name')));
                return;
              }
              final locService = LocationService();
              final pos = await locService.getCurrentLocation();
              if (pos == null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not capture GPS location.')));
                return;
              }

              provider.createSession(
                _courseController.text,
                int.tryParse(_durationController.text) ?? 15,
                pos.latitude,
                pos.longitude,
                double.tryParse(_radiusController.text) ?? 50.0,
              );
              _courseController.clear();
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 55)),
            child: const Text('Generate Token & QR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildSessionHistory(BuildContext context, AppProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Active & Recent Sessions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
          const SizedBox(height: 15),
          Expanded(
            child: provider.sessions.isEmpty 
              ? const Center(child: Text('No attendance tokens generated yet.', style: TextStyle(color: Colors.grey)))
              : ListView.builder(
              itemCount: provider.sessions.length,
              itemBuilder: (context, index) {
                final session = provider.sessions[provider.sessions.length - 1 - index];
                final isValid = session.isValid;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isValid ? Colors.green[100] : Colors.red[100],
                      child: Icon(
                        isValid ? Icons.online_prediction : Icons.timer_off_outlined, 
                        color: isValid ? Colors.green[800] : Colors.red[800],
                      ),
                    ),
                    title: Text(session.courseName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('CODE: ${session.sessionCode}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                        Text('Expires: ${session.endTime.hour}:${session.endTime.minute} | Limit: ${session.radius}m'),
                      ],
                    ),
                    trailing: isValid 
                    ? IconButton(
                      icon: const Icon(Icons.qr_code_2, color: Colors.blueAccent, size: 30),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => QRGeneratorScreen(session: session)));
                      },
                      tooltip: 'View QR',
                    )
                    : const Text('EXPIRED', style: TextStyle(fontSize: 10, color: Colors.red)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
