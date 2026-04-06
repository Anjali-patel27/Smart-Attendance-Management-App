import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ManualCodeScreen extends StatefulWidget {
  @override
  _ManualCodeScreenState createState() => _ManualCodeScreenState();
}

class _ManualCodeScreenState extends State<ManualCodeScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual Attendance Entry')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dialpad, size: 60, color: Colors.blueGrey),
            const SizedBox(height: 20),
            const Text(
              'Enter 6-Digit Code',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Confirm current session code from your instructor',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, letterSpacing: 10, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '000000',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              maxLength: 6,
            ),
            const SizedBox(height: 40),
            _isLoading 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 55)),
                  child: const Text('Verify & Save Attendance'),
                ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final code = _codeController.text.trim();
    if (code.length < 6) return;

    setState(() => _isLoading = true);
    
    try {
      final result = await context.read<AppProvider>().markAttendanceByCode(code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result), duration: const Duration(seconds: 4)));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Invalid or Expired Code')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
