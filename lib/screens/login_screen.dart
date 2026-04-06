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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blue[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user, size: 80, color: Colors.white),
              const SizedBox(height: 10),
              const Text(
                'EduTrack Systems',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const Text(
                'Modern Attendance Solution',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Secure Login',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _idController,
                        decoration: const InputDecoration(
                          labelText: 'Employee/Student ID',
                          prefixIcon: Icon(Icons.badge),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SegmentedButton<bool>(
                        segments: const <ButtonSegment<bool>>[
                          ButtonSegment<bool>(value: true, label: Text('Student'), icon: Icon(Icons.school)),
                          ButtonSegment<bool>(value: false, label: Text('Instructor'), icon: Icon(Icons.work)),
                        ],
                        selected: <bool>{_isStudent},
                        onSelectionChanged: (Set<bool> newSelection) {
                          setState(() {
                            _isStudent = newSelection.first;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 55),
                          elevation: 0,
                        ),
                        child: const Text('Login to System', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_nameController.text.trim().isEmpty || _idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter all fields')));
      return;
    }
    
    final user = User(
      id: _idController.text,
      name: _nameController.text,
      role: _isStudent ? 'student' : 'instructor',
      studentId: _isStudent ? _idController.text : null,
    );
    
    context.read<AppProvider>().login(user);
    
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (_) => _isStudent ? StudentDashboard() : InstructorDashboard()
      )
    );
  }
}
