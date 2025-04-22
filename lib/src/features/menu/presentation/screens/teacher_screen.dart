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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        questions[index],
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Row(
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
                                ratings[index] =
                                    starIndex + 1; // Cập nhật số sao
                              });
                            },
                          );
                        }),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Hiển thị kết quả đánh giá
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Kết quả đánh giá'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: questions.asMap().entries.map((entry) {
                            final questionIndex = entry.key;
                            final question = entry.value;
                            final rating = ratings[questionIndex] ?? 0;
                            return Text(
                                '$question: ${rating > 0 ? "$rating sao" : "Chưa đánh giá"}');
                          }).toList(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Đóng'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Xem kết quả'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
