import 'package:flutter/material.dart';

class TeacherEvaluationScreen extends StatefulWidget {
  const TeacherEvaluationScreen({super.key});

  @override
  _TeacherEvaluationScreenState createState() =>
      _TeacherEvaluationScreenState();
}

class _TeacherEvaluationScreenState extends State<TeacherEvaluationScreen> {
  // Danh sách câu hỏi
  final List<String> questions = [
    'Giảng viên có truyền đạt rõ ràng không?',
    'Giảng viên có nhiệt tình trong giảng dạy không?',
    'Bạn có hài lòng với phương pháp giảng dạy không?',
  ];

  // Lưu trữ số sao đánh giá cho từng câu hỏi
  final Map<int, int> ratings = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đánh giá giảng viên'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hãy đánh giá giảng viên:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            questions[index],
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: List.generate(5, (starIndex) {
                              return IconButton(
                                icon: Icon(
                                  starIndex < (ratings[index] ?? 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    ratings[index] = starIndex + 1;
                                  });
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Display confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đánh giá của bạn đã được gửi.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  // Optionally navigate back after a short delay
                  // Future.delayed(Duration(seconds: 2), () {
                  //   Navigator.pop(context);
                  // });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Gửi đánh giá', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
