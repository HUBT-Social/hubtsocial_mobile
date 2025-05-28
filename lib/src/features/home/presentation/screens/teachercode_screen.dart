import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/home/presentation/screens/teacher_screen.dart';

class TeacherCodeInputScreen extends StatelessWidget {
  final TextEditingController _codeController = TextEditingController();

  TeacherCodeInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập mã giảng viên'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vui lòng nhập mã giảng viên để tiếp tục:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Mã giảng viên',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_codeController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherEvaluationScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Vui lòng nhập mã giảng viên!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Tiếp tục'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
