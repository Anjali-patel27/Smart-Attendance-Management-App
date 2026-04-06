import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'login_screen.dart';
import 'qr_generator_screen.dart';
import '../services/location_service.dart';

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
        title: Text('Instructor : ${user?.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: () async {
              await provider.syncRecords();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Syncing done.')));
            },
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
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Create Session', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  TextField(controller: _courseController, decoration: const InputDecoration(labelText: 'Course Name')),
                  TextField(controller: _durationController, decoration: const InputDecoration(labelText: 'Duration (mins)'), keyboardType: TextInputType.number),
                  TextField(controller: _radiusController, decoration: const InputDecoration(labelText: 'Allowed Radius (m)'), keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_courseController.text.trim().isEmpty) return;
                      final locService = LocationService();
                      final pos = await locService.getCurrentLocation();
                      if (pos == null) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not get location.')));
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
                    child: const Text('Generate Session & QR'),
                  )
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: ListView.builder(
              itemCount: provider.sessions.length,
              itemBuilder: (context, index) {
                final session = provider.sessions[index];
                return ListTile(
                  title: Text(session.courseName),
                  subtitle: Text('Expires: ${session.endTime} | Validity: ${session.isValid}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.qr_code, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => QRGeneratorScreen(session: session)));
                    },
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
