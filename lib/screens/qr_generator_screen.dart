import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/models.dart';

class QRGeneratorScreen extends StatelessWidget {
  final AttendanceSession session;

  const QRGeneratorScreen({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final qrData = session.toQrData();

    return Scaffold(
      appBar: AppBar(title: Text('Session QR - ${session.courseName}')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 300.0,
            ),
            const SizedBox(height: 20),
            Text(
              'Valid until: ${session.endTime.hour}:${session.endTime.minute}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Radius: ${session.radius}m', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
