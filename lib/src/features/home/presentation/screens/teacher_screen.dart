import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/core/extensions/context.dart';
import 'package:hubtsocial_mobile/src/features/home/presentation/screens/teachercode_screen.dart'; // Import Teacher class

class TeacherEvaluationScreen extends StatefulWidget {
  final Teacher teacher;
  const TeacherEvaluationScreen({super.key, required this.teacher});

  @override
  _TeacherEvaluationScreenState createState() =>
      _TeacherEvaluationScreenState();
}

class _TeacherEvaluationScreenState extends State<TeacherEvaluationScreen> {
  // Danh sách câu hỏi
  // final List<String> questions = [
  //   'Giảng viên có truyền đạt rõ ràng, dễ hiểu không?',
  //   'Giảng viên có nhiệt tình, tận tâm trong giảng dạy không?',
  //   'Bạn có hài lòng với phương pháp giảng dạy của giảng viên không?',
  //   'Giảng viên có khuyến khích sinh viên đặt câu hỏi và tham gia thảo luận không?',
  //   'Giảng viên có cung cấp đủ tài liệu và nguồn học tập bổ ích không?',
  //   'Giảng viên có đánh giá công bằng và khách quan không?',
  //   'Giảng viên có giải quyết các vấn đề phát sinh một cách hiệu quả không?',
  //   'Bạn có cảm thấy được tôn trọng và lắng nghe khi tương tác với giảng viên không?',
  //   'Tổng thể, bạn có hài lòng với giảng viên này không?',
  // ];

  // Lưu trữ số sao đánh giá cho từng câu hỏi
  final Map<int, int> ratings = {};

  @override
  Widget build(BuildContext context) {
    final List<String> questions = [
      context.loc.question1,
      context.loc.question2,
      context.loc.question3,
      context.loc.question4,
      context.loc.question5,
      context.loc.question6,
      context.loc.question7,
      context.loc.question8,
      context.loc.question9,
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.teacherEvaluationTitle,
            style: context.textTheme.titleLarge
                ?.copyWith(color: context.colorScheme.onPrimary)),
        backgroundColor: context.colorScheme.primary, // Màu xanh mới
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 24.0),
                    color: context.colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.loc.teacherInfoTitle,
                            style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onSurface),
                          ),
                          const SizedBox(height: 16),
                          _buildInfoRow(context.loc.teacherNameLabel,
                              widget.teacher.name),
                          _buildInfoRow(context.loc.teacherCodeLabelShort,
                              widget.teacher.code),
                          _buildInfoRow(context.loc.teacherDepartmentLabel,
                              widget.teacher.department),
                          _buildInfoRow(context.loc.teacherGenderLabel,
                              widget.teacher.gender),
                          _buildInfoRow(context.loc.teacherBirthDateLabel,
                              widget.teacher.birthDate),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    context.loc.evaluationInstruction,
                    style: context.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.primary),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questions[index],
                          style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(5, (starIndex) {
                            return IconButton(
                              icon: Icon(
                                starIndex < (ratings[index] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: context.colorScheme.secondary, // Màu sao
                                size: 36,
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
              childCount: questions.length,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (ratings.length == questions.length) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.loc.evaluationSuccessMessage),
                        duration: const Duration(seconds: 2),
                        backgroundColor: context.colorScheme.primary,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.loc.evaluationErrorMessage),
                        duration: const Duration(seconds: 2),
                        backgroundColor: context.colorScheme.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary, // Màu nút
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 5,
                ),
                child: Text(context.loc.submitEvaluationButton,
                    style: context.textTheme.bodyLarge?.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 150),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.colorScheme.onSurface),
          ),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodyLarge
                  ?.copyWith(color: context.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}
