import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/models.dart';
import 'student_dashboard.dart';
import 'instructor_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  bool _isStudent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Attendance Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school, size: 100, color: Colors.blue),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'ID Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Login as: '),
                DropdownButton<bool>(
                  value: _isStudent,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('Student')),
                    DropdownMenuItem(value: false, child: Text('Instructor')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _isStudent = val ?? true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty || _idController.text.empty) return;
                final user = User(
                  id: _idController.text,
                  name: _nameController.text,
                  role: _isStudent ? 'student' : 'instructor',
                  studentId: _isStudent ? _idController.text : null,
                );
                
                context.read<AppProvider>().login(user);
                
                if (_isStudent) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StudentDashboard()));
                } else {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => InstructorDashboard()));
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              child: const Text('Login', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

extension on String {
  bool get empty => this.trim().isEmpty;
}
